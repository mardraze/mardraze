//Alternativa3D Class Export For Blender 2.62 and above
//Plugin Author: David E Jones, http://davidejones.com

package mouseeventsexample{

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
				VertexAttributes.TEXCOORDS[0],
				VertexAttributes.TEXCOORDS[0],
			];
			var g:Geometry = new Geometry();
			g.addVertexStream(attributes);
			g.numVertices = 24;
			
			/*var vertices:Array = [
				1, 1, -1,
				1, -1, -1,
				-1, -1, -1,
				-1, 1, -1,
				1, 0.999999, 1,
				0.999999, -1, 1,
				-1, -1, 1,
				-1, 1, 1,
			];
			*/
			var vertices:Array = [-50,-50,-50,-50,50,-50,50,-50,-50,50,50,-50,-50,-50,50,-50,50,50,50,-50,50,50,50,50,-50,-50,-50,-50,-50,50,50,-50,-50,50,-50,50,-50,50,-50,-50,50,50,50,50,-50,50,50,50,-50,-50,-50,-50,-50,50,-50,50,-50,-50,50,50,50,-50,-50,50,-50,50,50,50,-50,50,50,50]
			var uvlayer:Array = [1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0];

			var ind:Array = [3, 2, 0, 3, 0, 1, 4, 6, 7, 4, 7, 5, 8, 10, 11, 8, 11, 9, 12, 13, 15, 12, 15, 14, 16, 17, 19, 16, 19, 18, 20, 22, 23, 20, 23, 21];
			/*var normals:Array = [
				0.577349, 0.577349, -0.577349,
				0.577349, -0.577349, -0.577349,
				-0.577349, -0.577349, -0.577349,
				-0.577349, 0.577349, -0.577349,
				0.577349, 0.577349, 0.577349,
				0.577349, -0.577349, 0.577349,
				-0.577349, -0.577349, 0.577349,
				-0.577349, 0.577349, 0.577349,
			];*/
			var normals:Array = 
[0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0];


			
			var tangent:Array = [ -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, 1, 0, -1, 0, 1, 0, -1, 0, 1, 0, -1, 0, 1, 0, -1];
			
								

			g.setAttributeValues(VertexAttributes.POSITION, Vector.<Number>(vertices));
			g.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>(uvlayer));
			//g.setAttributeValues(VertexAttributes.NORMAL, Vector.<Number>(normals));
			//g.setAttributeValues(VertexAttributes.TANGENT4, Vector.<Number>(tangent));
			g.indices =  Vector.<uint>(ind);

			g.calculateNormals();
			g.calculateTangents(0);
			trace(g.getAttributeValues(VertexAttributes.TANGENT4));
			this.geometry = g;
			this.addSurface(Material, 0, 12);
			this.x = 0.000000;
			this.y = 0.000000;
			this.z = 0.000000;
			this.rotationX = 0.000000;
			this.rotationY = 0.000000;
			this.rotationZ = 0.000000;
			this.scaleX = 1.000000;
			this.scaleY = 1.000000;
			this.scaleZ = 1.000000;
		}
	}
}