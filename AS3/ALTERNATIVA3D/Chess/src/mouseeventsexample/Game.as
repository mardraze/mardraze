/**
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * If it is not possible or desirable to put the notice in a particular file, then You may include the notice in a location (such as a LICENSE file in a relevant directory) where a recipient would be likely to look for such a notice.
 * You may add additional accurate notices of copyright ownership.
 *
 * It is desirable to notify that Covered Software was "Powered by AlternativaPlatform" with link to http://www.alternativaplatform.com/ 
 * */

package mouseeventsexample {

	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.effects.TextureAtlas;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.ResourceLoader;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	import flash.automation.Configuration;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;

	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class Game extends Sprite {
		
		[Embed(source="texture.jpg")] static private const EmbedTexture:Class;
		[Embed(source="ChessBoard.jpg")] static private const ChessBoardEmbed:Class;

		[Embed(source="C:\\Users\\Marcin\\blender\\pawel\\wieza.a3d", mimeType="application/octet-stream")]
		private static const bumpClass:Class;

		static public const WHITE:String = "white";
		static public const BLACK:String = "black";

		private var scene:Object3D = new Object3D();
		
		private var camera:Camera3D;
		private var controller:SimpleObjectController;
		
		private var stage3D:Stage3D;
		private var error:Sprite3D;
		private var PAWN_DISTANCE:uint = 50;
		private var pawns:Object3D;
		private var mesh:Mesh;
		private var config:Config;
		private static var UNDEFINED:int = -1000000;
		private var tmpCameraX:Number = UNDEFINED;
		private var tmpCameraY:Number = UNDEFINED;
		private var tmpCameraZ:Number = UNDEFINED;
		private var tmpCameraRotationX:Number;
		private var tmpCameraRotationY:Number;
		private var tmpCameraRotationZ:Number;
		private var directionalLight:DirectionalLight;
		private var positions:Array;
		private var selected:Object;
		private var currentPlayer:String;

		public function Game() {
			config = new Config();
			config.ready(function():void {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				camera = new Camera3D(1, 1000);
				camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
				addChild(camera.view);
				addChild(camera.diagram);
				if (tmpCameraX !== UNDEFINED) {
					camera.x = tmpCameraX;
					camera.y = tmpCameraY;
					camera.z = tmpCameraZ;
					camera.rotationX = tmpCameraRotationX;
					camera.rotationY = tmpCameraRotationY;
					camera.rotationZ = tmpCameraRotationZ;
				}else {
					camera.x = config.values.camera.x;
					camera.y = config.values.camera.y;
					camera.z = config.values.camera.z;
					camera.rotationX = config.values.camera.rotationX * Math.PI/180;
					camera.rotationY = config.values.camera.rotationY * Math.PI/180;
					camera.rotationZ = config.values.camera.rotationZ * Math.PI/180;
				}
				controller = new SimpleObjectController(stage, camera, 50);
				initPositionArray();
				scene.addChild(camera);
				
				loadBoard();
				stage3D = stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
				stage3D.requestContext3D();
			});
			config.reload();
		}

		private function toXML(classObj:Class):XML {
			var contentfile:ByteArray = new classObj();
			var contentstr:String = contentfile.readUTFBytes( contentfile.length );
			return new XML( contentstr );
		}
		
		private function addLight():void {
			var omniLight:OmniLight = new OmniLight(0xf0f0ff, 50, 1000);
			omniLight.x = config.values.camera.x;
			omniLight.y = config.values.camera.y+200;
			omniLight.z = config.values.camera.z;
			omniLight.intensity = 3;
			var omniSphere:GeoSphere = new GeoSphere(10, 4, false, new FillMaterial(0xffffff));
			omniLight.addChild(omniSphere);
			scene.addChild(omniLight);
			var dirLight:DirectionalLight = new DirectionalLight(0x909030);
			dirLight.intensity = .5;
			dirLight.z = config.values.camera.z;
			dirLight.lookAt(0, 0, 0);
			scene.addChild(dirLight);
			var ambientLight:AmbientLight = new AmbientLight(0x404040);
			scene.addChild(ambientLight);
			var sphere:Mesh = null;
			var parser:ParserA3D = new ParserA3D();
			parser.parse(new bumpClass());
			for each (var obj:Object3D in parser.objects) {
				if (obj.name == "Sphere") {
					sphere = obj as Mesh;
					break;
				}
			}
			
			var data:Object = {
				"black" : [
					[3, 7], 
				], 
				"white" : [
					[3, 0], 
				]
			};

			putFigures("King", sphere, data);
			return;
			sphere.geometry.addVertexStream([VertexAttributes.TEXCOORDS[0], VertexAttributes.TEXCOORDS[0]]);
			sphere.geometry.calculateNormals();
			sphere.geometry.calculateTangents(0);
			
			trace("boundBox", JSON.stringify(sphere.boundBox));
			sphere.x = camera.x;
			sphere.y = camera.y + 300;
			sphere.z = camera.z - 100;
			sphere.scaleX = 5;
			sphere.scaleY = 5;
			sphere.scaleZ = 5;
			var btr:BitmapTextureResource = createColorTexture(0x00FF00);
			var btr1:BitmapTextureResource = createColorTexture(0xFF0000);
			sphere.setMaterialToAllSurfaces(new StandardMaterial(btr, btr1));
			scene.addChild(sphere);
		}
    public static function coloredStandardMaterial(color:int = 0x7F7F7F):StandardMaterial {
        var material:StandardMaterial;
        material = new StandardMaterial(createColorTexture(color), createColorTexture(0x7F7FFF));
        return material;
    }

    public static function createColorTexture(color:uint, alpha:Boolean = false):BitmapTextureResource {
        return new BitmapTextureResource(new BitmapData(1, 1, alpha, color));
    }

		private function loadBoard():void {
			var box:Box = new Box(512, 512, 32);
			var chessBoardMaterial:Material = new TextureMaterial(new BitmapTextureResource(new ChessBoardEmbed().bitmapData));
			var brownMaterial:Material = new FillMaterial(0x621a21);
			box.setMaterialToAllSurfaces(brownMaterial);
			box.addSurface(chessBoardMaterial, 6, 2);
			box.addEventListener(MouseEvent3D.CLICK, onBoardClick);
			scene.addChild(box);
		}
				
		private function move(x:int, y:int, clickedFigure:Mesh = null, color:String = null):void {
			//jesli zaznaczony i moze sie tutaj ruszyc
				//jesli nie ma koloru - przejdz na pozycje
				//jesli moj kolor - zmien selected
				//jesli color przeciwnika - zbij, selected odznacz, zmien ture
			//niezaznaczony
				//jesli jest parametr figure i tura color to zaznacz
			CONFIG::debug { trace('move 1'); }
			if (canMoveSelected(x, y)) {
				CONFIG::debug { trace('move 2'); }
				if (color) {
					CONFIG::debug { trace('move 3'); }
					if (color === currentPlayer) {
						CONFIG::debug { trace('move 4'); }
						selected = { 
							'x' : x,
							'y' : y,
							'figureName' : clickedFigure.name,
							'type' : clickedFigure.name.substr(0, clickedFigure.name.search('_')),
							'color' : color
						};
					} else {
						CONFIG::debug { trace('move 5'); }
						positions[selected.x][selected.y] = { 'figureName' : null, 'color' : null };
						positions[x][y] = { 'figureName' : selected.figureName, 'color' : selected.color };
						var figure1:Mesh = scene.getChildByName(selected.figureName) as Mesh;
						figure1.x = config.values.mesh.x + config.values.pawnDistance * x;
						figure1.y = config.values.mesh.y + config.values.pawnDistance * y;
						clickedFigure.visible = false;
						nextPlayer();
					}
				} else {
					CONFIG::debug { trace('move 8'); }
					positions[selected.x][selected.y] = { 'figureName' : null, 'color' : null };
					positions[x][y] = { 'figureName' : selected.figureName, 'color' : selected.color };
					var figure:Mesh = scene.getChildByName(selected.figureName) as Mesh;
					figure.x = config.values.mesh.x + config.values.pawnDistance * x;
					figure.y = config.values.mesh.y + config.values.pawnDistance * y;
					nextPlayer();
				}
			}else if (clickedFigure && currentPlayer === color) {
				CONFIG::debug { trace('move 9'); }
				selected = { 
					'x' : x,
					'y' : y,
					'figureName' : clickedFigure.name,
					'type' : clickedFigure.name.substr(0, clickedFigure.name.search('_')),
					'color' : color
				};
			}
			CONFIG::debug { trace('move 10'); }

		}
		
		private function nextPlayer():void {
			if (currentPlayer === BLACK) {
				currentPlayer = WHITE;
				CONFIG::debug { trace('move 6'); }
			}else {
				currentPlayer = BLACK;
				CONFIG::debug { trace('move 7'); }
			}
			selected = null;
		}
		
		private function canMoveSelected(x:int, y:int):Boolean {
			if (!selected || (x === selected.x && y === selected.y)) 
				return false;
			
			CONFIG::debug { trace('canMoveSelected '+selected.type+' (' + selected.x + ',' + selected.y + ') => (' + x + ',' + y + ')'); }
			switch(selected.type) {
				case "King" : 
					return (Math.abs(x - selected.x) <= 1 && Math.abs(y - selected.y) <= 1 );
				case "Bishop" : 
					return Math.abs(x - selected.x) ===  Math.abs(y - selected.y);
				
			}
			return false;
		}
		
		private function onBoardClick(e:MouseEvent3D):void {
			var x:int = Math.round((e.localX - parseInt(config.values.mesh.x)) / config.values.pawnDistance);
			var y:int = Math.round((e.localY - parseInt(config.values.mesh.y)) / config.values.pawnDistance);
			CONFIG::debug { trace('onBoardClick (' + x + ',' + y + ')'); }
			
			if (positions[x][y].color) {
				var figure:Mesh = scene.getChildByName(positions[x][y].figureName) as Mesh;
				move(x, y, figure, positions[x][y].color);
			}else {
				move(x, y);
			}
			
		}

		///////////////////////////////// FIGURES //////////////////////////////////////////
		
		private function onContextCreate(e:Event):void {
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			addLight();
			loadPawns();
			loadRooks();
			loadKnight();
			loadBishop();
			loadQueens();
			loadKings();
			uploadResources(scene.getResources(true));

			camera.render(stage3D);

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		private function putFigures(name:String, mesh:Mesh, data:Object):void {
			mesh.geometry.addVertexStream([VertexAttributes.TEXCOORDS[0], VertexAttributes.TEXCOORDS[0]]);
			mesh.geometry.calculateNormals();
			mesh.geometry.calculateTangents(0);
			mesh.x = config.values.mesh.x;
			mesh.y = config.values.mesh.y;
			mesh.z = config.values.mesh.z;
			mesh.scaleX = config.values.mesh.scaleX;
			mesh.scaleY = config.values.mesh.scaleY;
			mesh.scaleZ = config.values.mesh.scaleZ;
			//trace("INDICES", JSON.stringify(mesh.geometry.indices));
			//trace("POSITION", JSON.stringify(mesh.geometry.getAttributeValues(VertexAttributes.POSITION)));
			//trace("NORMAL", JSON.stringify(mesh.geometry.getAttributeValues(VertexAttributes.NORMAL)));
			//trace("TEXCOORDS", JSON.stringify(mesh.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0])));

			mesh.geometry.upload(stage3D.context3D);
			var whiteMesh:Mesh = mesh as Mesh;
			var blackMesh:Mesh = mesh.clone() as Mesh;
			whiteMesh.setMaterialToAllSurfaces(coloredStandardMaterial());//new FillMaterial(0xFBF2ED));
			blackMesh.setMaterialToAllSurfaces(coloredStandardMaterial());//new FillMaterial(0x000000));
			uploadResources(mesh.getResources(false, Geometry));
			for each(var coordWhite:Array in data.white) {
				var whiteFigure:Object3D = whiteMesh.clone();
				whiteFigure.name = name + '_' + coordWhite[0] + '_' + coordWhite[1];
				whiteFigure.x += config.values.pawnDistance * coordWhite[0];
				whiteFigure.y += config.values.pawnDistance * coordWhite[1];
				positions[coordWhite[0]][coordWhite[1]].figureName = whiteFigure.name;
				positions[coordWhite[0]][coordWhite[1]].color = WHITE;
				scene.addChild(whiteFigure);
				whiteFigure.addEventListener(MouseEvent3D.MOUSE_UP, onWhiteClick);
			}
			for each(var coordBlack:Array in data.black) {
				var blackFigure:Object3D = blackMesh.clone();
				blackFigure.name = name + '_' + coordBlack[0] + '_' + coordBlack[1];
				blackFigure.x += config.values.pawnDistance * coordBlack[0];
				blackFigure.y += config.values.pawnDistance * coordBlack[1];
				positions[coordBlack[0]][coordBlack[1]].figureName = blackFigure.name;
				positions[coordBlack[0]][coordBlack[1]].color = BLACK;
				scene.addChild(blackFigure);
				blackFigure.addEventListener(MouseEvent3D.MOUSE_UP, onBlackClick);
			}
		}
		
		private function loadQueens():void {
			loadPath("C:\\Users\\Marcin\\blender\\pawel\\wieza.a3d", function(e:Event):void {
				var mesh:Mesh = onResourceLoaded(e);
				var data:Object = {
						"black" : [
							[3, 7], 
						], 
						"white" : [
							[3, 0], 
						]
					};
				putFigures("Queen", mesh, data);
			});
		}

		private function loadKings():void {
			loadPath("C:\\Users\\Marcin\\blender\\pawel\\wieza.a3d", function(e:Event):void {
				var mesh:Mesh = onResourceLoaded(e);
				var data:Object = {
						"black" : [
							[4, 7], 
						], 
						"white" : [
							[4, 0], 
						]
					};
				putFigures("King", mesh, data);
			});
		}
		
		private function loadBishop():void {
			loadPath("C:\\Users\\Marcin\\blender\\pawel\\wieza.a3d", function(e:Event):void {
				var mesh:Mesh = onResourceLoaded(e);
				var data:Object = {
						"black" : [
							[2, 7], 
							[5, 7],
						], 
						"white" : [
							[2, 0], 
							[5, 0],
						]
					};
				putFigures("Bishop", mesh, data);
			});
		}

		private function loadKnight():void {
			loadPath("C:\\Users\\Marcin\\blender\\pawel\\wieza.a3d", function(e:Event):void {
				var mesh:Mesh = onResourceLoaded(e);
				var data:Object = {
						"black" : [
							[1, 7], 
							[6, 7],
						], 
						"white" : [
							[1, 0], 
							[6, 0],
						]
					};
				putFigures("Knight", mesh, data);
			});
		}
		
		private function loadRooks():void {
			loadPath("C:\\Users\\Marcin\\blender\\pawel\\wieza.a3d", function(e:Event):void {
				var mesh:Mesh = onResourceLoaded(e);
				var data:Object = {
						"black" : [
							[0, 7], 
							[7, 7],
						], 
						"white" : [
							[0, 0], 
							[7, 0],
						]
					};
				putFigures("Rook", mesh, data);
			});
		}
		
		private function loadPawns():void {
			loadPath("C:\\Users\\Marcin\\blender\\pawel\\pionek 2.a3d", function(e:Event):void {
				var mesh:Mesh = onResourceLoaded(e);
				var data:Object = {
						"black" : [
							[0, 6],
							[1, 6],
							[2, 6],
							[3, 6],
							[4, 6],
							[5, 6],
							[6, 6],
							[7, 6],
						],
						"white" : [
							[0, 1],
							[1, 1], 
							[2, 1], 
							[3, 1], 
							[4, 1], 
							[5, 1], 
							[6, 1], 
							[7, 1], 
						]
					};
				putFigures("Pawn", mesh, data);
			});
		}

		private function onResourceLoaded(e:Event):Mesh {
			var parser:ParserA3D = new ParserA3D();
			parser.parse((e.target as URLLoader).data);
			trace(parser.objects);
			for each (var obj:Object3D in parser.objects) {
				if (obj.name == "Sphere") {
					return obj as Mesh;
				}
			}
			return null;
		}

		private function loadPath(path:String, ready:Function):void {
			var loaderA3D:URLLoader = new URLLoader();
			loaderA3D.dataFormat = URLLoaderDataFormat.BINARY;
			loaderA3D.load(new URLRequest(path));
			loaderA3D.addEventListener(Event.COMPLETE, ready);
		}
				
		private function uploadResources(resources:Vector.<Resource>):void {
			for each (var resource:Resource in resources) {
				resource.upload(stage3D.context3D);
			}
		}
		
		private function reloadConfig():void {
			tmpCameraX = camera.x;
			tmpCameraY = camera.y;
			tmpCameraZ = camera.z;
			tmpCameraRotationX = camera.rotationX;
			tmpCameraRotationY = camera.rotationY;
			tmpCameraRotationZ = camera.rotationZ;
			config.reload();
		}
		
		private function onWhiteClick(e:Event):void {
			var figure:Mesh = (e.target as Mesh);
			var x:int = Math.round((figure.x - parseInt(config.values.mesh.x)) / config.values.pawnDistance);
			var y:int = Math.round((figure.y - parseInt(config.values.mesh.y)) / config.values.pawnDistance);
			CONFIG::debug {
				trace('onPawnClick (' + x + ',' + y + ') (' + figure.x + ',' + figure.y + ')'+JSON.stringify(positions));
			}
			move(x, y, figure, WHITE);
		}
		
		private function onBlackClick(e:Event):void {
			var figure:Mesh = (e.target as Mesh);
			var x:int = Math.round((figure.x - parseInt(config.values.mesh.x)) / config.values.pawnDistance);
			var y:int = Math.round((figure.y - parseInt(config.values.mesh.y)) / config.values.pawnDistance);
			CONFIG::debug {
				trace('onBlackClick (' + x + ',' + y + ') (' + figure.x + ',' + figure.y + ')');
			}
			move(x, y, figure, BLACK);
		}
		
		private function initPositionArray():void {
			positions = new Array();
			for (var i:int = 0; i < 8; i++ ) {
				positions[i] = new Array();
				for (var j:int = 0; j < 8; j++ ) {
					positions[i][j] = { 
						'figureName' : null,
						'color' : null
					};
				}
			}
			selected = null;
			currentPlayer = WHITE;
		}
		
		private function onEnterFrame(e:Event):void {
			controller.update();
			camera.render(stage3D);
		}
		
		private function onResize(e:Event = null):void {
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
		}
	}
}
