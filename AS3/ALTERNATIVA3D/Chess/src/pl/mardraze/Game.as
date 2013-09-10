/**
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * If it is not possible or desirable to put the notice in a particular file, then You may include the notice in a location (such as a LICENSE file in a relevant directory) where a recipient would be likely to look for such a notice.
 * You may add additional accurate notices of copyright ownership.
 *
 * It is desirable to notify that Covered Software was "Powered by AlternativaPlatform" with link to http://www.alternativaplatform.com/ 
 * */

package pl.mardraze {

	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;


	public class Game extends Sprite {
		
		[Embed(source = "ChessBoard.jpg")] 
		static private const ChessBoardEmbed:Class;
		private var scene:Object3D = new Object3D();
		private var camera:Camera3D;
		private var controller:SimpleObjectController;
		private var stage3D:Stage3D;
		private var config:Config;
		private var cameraPosition:Object = {};
		private var logic:Logic;

		public function Game() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			camera = new Camera3D(1, 1000);
			camera.name = 'camera';
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			camera.view.name = 'view';
			camera.diagram.name = 'diagram';
			addChild(camera.view);
			addChild(camera.diagram);
			scene.addChild(camera);
			CONFIG::debug {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
					if (e.keyCode == 80) {
						trace(camera.x, camera.y, camera.z,
							camera.rotationX / (Math.PI / 180),
							camera.rotationY / (Math.PI / 180), 
							camera.rotationZ / (Math.PI / 180));
					}
				});
			}
			initLogic();
			loadBoard();
			config = new Config();
			config.ready(function():void {
				if (x in cameraPosition) {
					camera.x = cameraPosition.x;
					camera.y = cameraPosition.y;
					camera.z = cameraPosition.z;
					camera.rotationX = cameraPosition.rotationX;
					camera.rotationY = cameraPosition.rotationY;
					camera.rotationZ = cameraPosition.rotationZ;
				}else {
					camera.x = config.values.camera.x;
					camera.y = config.values.camera.y;
					camera.z = config.values.camera.z;
					camera.rotationX = config.values.camera.rotationX * Math.PI/180;
					camera.rotationY = config.values.camera.rotationY * Math.PI/180;
					camera.rotationZ = config.values.camera.rotationZ * Math.PI/180;
				}
				controller = new SimpleObjectController(stage, camera, 50);
				stage3D = stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
				stage3D.requestContext3D();
			});
			config.reload();
		}
		
		private function initLogic():void {
			logic = new Logic();
			
			logic.callGetFigureUpgradePawn = function():String { 
				return Logic.FIGURE_QUEEN;
			};
			
			logic.callCloneFigure = function(choosenFigureName:String, newFigureName:String, x:int, y:int):void {
				var mesh:Mesh = scene.getChildByName(choosenFigureName) as Mesh;
				var newFigure:Mesh = mesh.clone() as Mesh;
				newFigure.name = newFigureName;
				newFigure.x = x;
				newFigure.y = y;
				newFigure.visible = true;
				scene.addChild(newFigure);
			};
			
			logic.callHideFigure = function(name:String):void { 
				var oldPawn:Mesh = scene.getChildByName(name) as Mesh;
				oldPawn.visible = false;
			};
			
			logic.callMoveFigure = function(selectedFigureName:String, x:int, y:int):void {
				var figure2:Mesh = scene.getChildByName(selectedFigureName) as Mesh;
				figure2.x = config.values.mesh.x + config.values.pawnDistance * x;
				figure2.y = config.values.mesh.y + config.values.pawnDistance * y;
			};
			
			logic.callEndGame = function(result:Object):void {
				trace('END GAME');
			};

			logic.start();
		}
		
		private function addLight():void {
			var omniLight:OmniLight = new OmniLight(0x666, 50, 1000);
			omniLight.x = config.values.camera.x;
			omniLight.y = config.values.camera.y+850;
			omniLight.z = config.values.camera.z-200;
			omniLight.intensity = 3;
			var omniSphere:GeoSphere = new GeoSphere(10, 4, false, new FillMaterial(0xffffff));
			omniLight.addChild(omniSphere);
			scene.addChild(omniLight);
			var dirLight:DirectionalLight = new DirectionalLight(0x909030);
			dirLight.intensity = .8;
			dirLight.z = config.values.camera.z;
			dirLight.lookAt(0, 0, 0);
			scene.addChild(dirLight);
			var ambientLight:AmbientLight = new AmbientLight(0x404040);
			scene.addChild(ambientLight);
		}

		private function loadBoard():void {
			var box:Box = new Box(512, 512, 32);
			box.name = 'board';
			var chessBoardMaterial:Material = new TextureMaterial(new BitmapTextureResource(new ChessBoardEmbed().bitmapData));
			var brownMaterial:Material = new FillMaterial(0x621a21);
			box.setMaterialToAllSurfaces(brownMaterial);
			box.addSurface(chessBoardMaterial, 6, 2);
			box.addEventListener(MouseEvent3D.CLICK, onBoardClick);
			scene.addChild(box);
		}
		
		private function pixelsToX(px:Number):int {
			return Math.round((px - parseInt(config.values.mesh.x)) / config.values.pawnDistance);
		}

		private function pixelsToY(py:Number):int {
			return Math.round((py - parseInt(config.values.mesh.y)) / config.values.pawnDistance);
		}

		private function onBoardClick(e:MouseEvent3D):void {
			var x:int = pixelsToX(e.localX);
			var y:int = pixelsToY(e.localY);
			CONFIG::debug { trace('onBoardClick (' + x + ',' + y + ')'); }
			logic.onFieldClick(x, y);
		}
		
		private function onFigureClick(e:MouseEvent3D):void {
			var figure:Mesh = (e.target as Mesh);
			var x:int = pixelsToX(figure.x);
			var y:int = pixelsToY(figure.y);
			CONFIG::debug { trace('onFigureClick (' + x + ',' + y + ')'); }
			logic.onFieldClick(x, y);
		}

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
			mesh.geometry.upload(stage3D.context3D);
			var whiteMesh:Mesh = mesh as Mesh;
			var blackMesh:Mesh = mesh.clone() as Mesh;
			whiteMesh.setMaterialToAllSurfaces(Utils.coloredStandardMaterial(0xFBF2ED));
			blackMesh.setMaterialToAllSurfaces(Utils.coloredStandardMaterial(0x000000));
			uploadResources(mesh.getResources(false, Geometry));
			var coord:Array;
			for each(coord in data.white) {
				var whiteFigure:Object3D = whiteMesh.clone();
				whiteFigure.name = logic.getNameByCoord(name, coord[0], coord[1]);
				whiteFigure.x += config.values.pawnDistance * coord[0];
				whiteFigure.y += config.values.pawnDistance * coord[1];
				scene.addChild(whiteFigure);
				uploadResources(whiteFigure.getResources(false));
				whiteFigure.addEventListener(MouseEvent3D.MOUSE_UP, onFigureClick);
			}
			for each(coord in data.black) {
				var blackFigure:Object3D = blackMesh.clone();
				blackFigure.name = logic.getNameByCoord(name, coord[0], coord[1]);
				blackFigure.x += config.values.pawnDistance * coord[0];
				blackFigure.y += config.values.pawnDistance * coord[1];
				scene.addChild(blackFigure);
				uploadResources(blackFigure.getResources(false));
				blackFigure.addEventListener(MouseEvent3D.MOUSE_UP, onFigureClick);
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
			//trace(parser.objects);
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
			cameraPosition.x = camera.x;
			cameraPosition.y = camera.y;
			cameraPosition.z = camera.z;
			cameraPosition.rotationX = camera.rotationX;
			cameraPosition.rotationY = camera.rotationY;
			cameraPosition.rotationZ = camera.rotationZ;
			config.reload();
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
