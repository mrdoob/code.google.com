/**
 * Papervision3D Previewer
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 *  09.02.01		1.3		Trent Grover	+ New camera system
 *  										+ Additional supported model types
 *  										+ Animation playback
 *  										+ Added model scale change using up and down arrow keys
 *  										+ Mouse click selects current mesh for scale change or animation playback
 *  						Mr.doob			+ General code clean up
 *	08.02.22		1.2		Mr.doob			+ Refactoring (in other words, re-coded from scratch)
 *											+ Using Papervision3D 2.0
 *	07.06.13		1.1		Mr.doob			+ MacOS support
 *											+ Triangles rendered stats added on the FPS bar
 *											+ Object loaded now rotates automatically
 *											+ Camera behaviour amended 
 * 	07.04.27		1.0		Mr.doob			+ Big bang
 *
 **/

package
{
	import Config;
	import net.hires.debug.Stats;

	import utils.*;

	import org.papervision3d.cameras.*;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.special.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.parsers.*;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.ui.ContextMenuItem;	

	[SWF(width="800",height="600",backgroundColor="#101010")]

	public class Main extends Sprite
	{
		public var fileRef : FileReference;

		public var camera : Camera3D;
		public var scene : Scene3D;
		public var renderer : BasicRenderEngine;
		public var viewport : Viewport3D;

		public var mesh : DisplayObject3D;

		public var CAMERA_VIEW_TOP : String = "top";
		public var CAMERA_VIEW_BOTTOM : String = "bottom";
		public var CAMERA_VIEW_LEFT : String = "left";
		public var CAMERA_VIEW_RIGHT : String = "right";
		public var CAMERA_VIEW_FRONT : String = "front";
		public var CAMERA_VIEW_BACK : String = "back";
		public var CAMERA_VIEW_PERS : String = "pers";
		public var CAMERA_VIEW : String = CAMERA_VIEW_PERS;

		public function Main()
		{
			Config.setup(this);
			init();
			addChild(new Stats());
		}

		public function init() : void
		{
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, onFileSelect);

			init3D();

			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
			addEventListener(Event.ENTER_FRAME, loop);	
		}

		public function init3D() : void
		{
			scene = new Scene3D();
			renderer = new BasicRenderEngine();
			viewport = new Viewport3D(800, 600, true, true);
			addChild(viewport);

			camera = new Camera3D();
			camera.zoom = 100;
			camera.x = 0;
			camera.z = -1500;
			camera.y = 0;

			scene.addChild(new PlaneGrid3D());

			/*
			// create a test cube primitive
			var materials:MaterialsList = new MaterialsList(
			{
			front:  new ColorMaterial(0xFFFFFF),
			back:   new ColorMaterial(0xFF0000),
			right:  new ColorMaterial(0x00FF00),
			left:   new ColorMaterial(0x333333),
			top:    new ColorMaterial(0x0000FF),
			bottom: new ColorMaterial(0xFFFF00)
			});
			scene.addChild(new Cube(materials, 300, 300, 300));
			 */

			// Context Menu
			var cmiLoad : ContextMenuItem = new ContextMenuItem("Load Mesh", true);
			cmiLoad.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openFileSelector);
			Config.cm.customItems.push(cmiLoad);
		}

		
		// .. LOOP ............................................................................................................

		public function loop(e : Event) : void
		{
			handleCamera();
			renderer.renderScene(scene, camera, viewport);
		}

		public function handleCamera() : void
		{
			if (CAMERA_VIEW == CAMERA_VIEW_PERS)
			{
				// if pitch == 0, everything disappears?
				var pitch : Number = (-mouseY * 0.2);
				if (pitch >= 0)
					pitch = -0.1;
				camera.orbit(pitch, mouseX * 0.2);
			}
		}

		
		// .. USER INPUT .....................................................................................................

		public function onKeyboardEvent(e : KeyboardEvent) : void
		{
			switch(e.type)
			{
				case KeyboardEvent.KEY_UP:

					switch(e.keyCode)
					{
						// swap viewpoints
						case String("T").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_TOP;		
							camera.orbit(-0.1, 270);		
							break;
						case String("B").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_BOTTOM;	
							camera.orbit(-179.9, 270);	
							break;
						case String("L").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_LEFT;		
							camera.orbit(-90, 0);		
							break;
						case String("R").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_RIGHT;	
							camera.orbit(-90, 180);		
							break;
						case String("F").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_FRONT;	
							camera.orbit(-90, 270);		
							break;
						case String("A").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_BACK;		
							camera.orbit(-90, 90);		
							break;
						case String("P").charCodeAt():	
							CAMERA_VIEW = CAMERA_VIEW_PERS;									
							break;
						case 38:	
							mesh.scale += 1;		
							break;
						case 40:	
							if (mesh.scale > 1)
										mesh.scale -= 1;
							break;
					}

					break;
			}
		}

		public function onMouseEvent(e : MouseEvent) : void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_WHEEL:	
					camera.zoom += e.delta;		
					break;
			}
		}

		
		// .. FILE HANDLING .....................................................................................................

		public function openFileSelector(e : Event = null) : void
		{
			var fileTypes : Array = new Array(new FileFilter("3D Files (*.ase, *.dae, *.3ds, *.md2, *.kmz)", "*.ase; *.dae; *.3ds; *.md2; *.kmz"));

			try
			{
				fileRef.browse(fileTypes) as Boolean;
			}
			catch (error : Error)
			{
				trace("Unable to browse for files.");
			}
		}

		public function openTextureSelector(e : Event = null) : void
		{
			var fileTypes : Array = new Array(new FileFilter("Bitmap Files (*.jpg, *.png, *.gif)", "*.jpg; *.png; *.gif"));

			try
			{
				fileRef.browse(fileTypes) as Boolean;
			}
			catch (error : Error)
			{
				trace("Unable to browse for files.");
			}
		}

		public function onFileSelect(e : Event) : void
		{
			var file : FileReference = FileReference(e.target);
			var file_type : String = FileUtils.getFileType(file.name).toLowerCase();

			switch(file_type)
			{
				case ".jpg":
				case ".png":
				case ".gif":
					loadTexture(file.name);
					break;
				case ".ase":
				case ".dae":
				case ".3ds":
				case ".md2":
				case ".kmz":
					loadMesh(file.name, file_type);
					break;
			}
		}

		public function loadMesh(file_name : String, file_extension : String = null) : void
		{
			if (!file_extension)
				file_extension = FileUtils.getFileType(file_name);

			switch(file_extension)
			{
				case ".ase":

					mesh = new Ase(new ColorMaterial(Math.random() * 0xffffff), file_name, .1);
					mesh.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleMesh);
					break;

				case ".dae":

					mesh = new DAE();
					mesh.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleMesh);
					mesh.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, handleDAEanim);
					DAE(mesh).load(file_name);
					break;

				case ".3ds":

					mesh = new Max3DS();
					mesh.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleMesh);
					Max3DS(mesh).load(file_name);
					break;

				case ".md2":

					mesh = new MD2();
					mesh.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleMD2);
					MD2(mesh).load(file_name);
					break;

				case ".kmz":

					mesh = new KMZ();
					mesh.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleMesh);
					KMZ(mesh).load(file_name);
					break;
			}
		}

		public function loadTexture(file_name : String) : void
		{
			mesh.material = new BitmapFileMaterial(file_name);
			mesh.material.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleTexture);
		}

		public function handleTexture(e : FileLoadEvent) : void
		{
			addHighlight(mesh);
		}

		public function handleMD2(e : FileLoadEvent) : void
		{
			openTextureSelector();
			mesh.rotationZ = mesh.rotationY = 90;
			scene.addChild(mesh);
		}

		public function handleMesh(e : FileLoadEvent) : void
		{
			addHighlight(mesh);
			scene.addChild(mesh);
		}

		public function handleDAEanim(e : Event) : void
		{
			DAE(mesh).play();
		}

		public function addHighlight(object : DisplayObject3D) : void
		{
			if (object.children)
				for each(var child : DisplayObject3D in object.children)
					addHighlight(child);

			if (!object.material)			return;
			if (!object.geometry.faces[0])	return;

			var original : MaterialObject3D;

			// This is a workaround for a bug. object.material should have the updated material
			// but for some reason its stuck on WireframeMaterial
			if (object.geometry.faces[0].material)
				original = object.geometry.faces[0].material;
			else
				original = object.material;

			var material : CompositeMaterial = new CompositeMaterial();
			material.addMaterial(original);
			material.addMaterial(new ColorMaterial(0x00ff00, 0));
			material.interactive = true;
			object.material = material;

			object.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onInteractiveEvent);
			object.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onInteractiveEvent);
			object.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onInteractiveEvent);
		}

		
		// .. 3D LISTENERS

		public function onInteractiveEvent(e : InteractiveScene3DEvent) : void
		{
			switch(e.type)
			{
				case InteractiveScene3DEvent.OBJECT_OVER:

					// turn on the highlight
					CompositeMaterial(e.displayObject3D.material).materials[1].fillAlpha = 0.5;
					break;

				case InteractiveScene3DEvent.OBJECT_OUT:

					// turn off the highlight
					CompositeMaterial(e.displayObject3D.material).materials[1].fillAlpha = 0;
					break;

				case InteractiveScene3DEvent.OBJECT_CLICK:

					// activate the selected mesh (for scale commands, etc)
					// (must first traverse to the parent Ase or DAE)
					var target : DisplayObject3D = e.displayObject3D;
					
					while (!((target is DAE) || (target is Ase) || (target is Max3DS) || (target is MD2) || (target is KMZ)) && (target.parent != null))
						target = DisplayObject3D(target.parent);
						
					if ((target is DAE) || (target is Ase) || (target is Max3DS) || (target is MD2) || (target is KMZ))
						mesh = target;

					// trigger DAE animation
					if (mesh is DAE)
						DAE(mesh).play();
					
					break;
			}
		}
	}
}