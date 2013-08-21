//Alternativa3D Class Export For Blender 2.62 and above
//Plugin Author: David E Jones, http://davidejones.com

package mouseeventsexample {

	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	import __AS3__.vec.Vector;
	import flash.display.Bitmap;

	public class Cube extends Mesh {

		private var Material:FillMaterial = new FillMaterial(0xcccccc);

		private var attributes:Array;

		public function Cube() {

			attributes = [
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.NORMAL,
				VertexAttributes.NORMAL,
				VertexAttributes.NORMAL,
				VertexAttributes.TANGENT4,
				VertexAttributes.TANGENT4,
				VertexAttributes.TANGENT4,
				VertexAttributes.TANGENT4,
			];
			var g:Geometry = new Geometry();
			g.addVertexStream(attributes);
			g.numVertices = 8;

			var vertices:Array = [
				1, 1, -1,
				1, -1, -1,
				-1, -1, -1,
				-1, 1, -1,
				1, 0.999999, 1,
				0.999999, -1, 1,
				-1, -1, 1,
				-1, 1, 1,
			];
			var uvlayer:Array = new Array();
			var ind:Array = new Array();
			var normals:Array = [
				0.577349, 0.577349, -0.577349,
				0.577349, -0.577349, -0.577349,
				-0.577349, -0.577349, -0.577349,
				-0.577349, 0.577349, -0.577349,
				0.577349, 0.577349, 0.577349,
				0.577349, -0.577349, 0.577349,
				-0.577349, -0.577349, 0.577349,
				-0.577349, 0.577349, 0.577349,
			];
			var tangent:Array = new Array();

			g.setAttributeValues(VertexAttributes.POSITION, Vector.<Number>(vertices));
			//g.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvlayer));
			g.setAttributeValues(VertexAttributes.NORMAL, Vector.<Number>(normals));
			//g.setAttributeValues(VertexAttributes.TANGENT4, Vector.<Number>(tangent));
			g.indices =  Vector.<uint>(ind);

			//g.calculateNormals();
			//g.calculateTangents(0);
			this.geometry = g;
			this.addSurface(Material, 0, 12);
			this.calculateBoundBox();

			this.x = 0.000000;
			this.y = 0.000000;
			this.z = 0.000000;
			this.rotationX = 0.000000;
			this.rotationY = -0.000000;
			this.rotationZ = 0.000000;
			this.scaleX = 1.000000;
			this.scaleY = 1.000000;
			this.scaleZ = 1.000000;

			var bb:BoundBox = new BoundBox();
			bb.maxX = -1.000000;
			bb.maxY = -1.000001;
			bb.maxZ = -1.000000;
			bb.minX = 1.000000;
			bb.minY = 1.000000;
			bb.minZ = 1.000000;
			this.boundBox = bb;
		}
	}
}