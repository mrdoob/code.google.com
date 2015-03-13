package com.mrdoob.tools.threedoob.renderers 
{
	import com.mrdoob.tools.threedoob.cameras.Camera3D;
	import com.mrdoob.tools.threedoob.core.Triangle3D;
	import com.mrdoob.tools.threedoob.core.Vector3D;
	import com.mrdoob.tools.threedoob.core.Vertex3D;
	import com.mrdoob.tools.threedoob.events.Scene3DEvent;
	import com.mrdoob.tools.threedoob.materials.BitmapMaterial3D;
	import com.mrdoob.tools.threedoob.materials.ColorMaterial3D;
	import com.mrdoob.tools.threedoob.materials.WireframeMaterial3D;
	import com.mrdoob.tools.threedoob.objects.BitmapDof3D;
	import com.mrdoob.tools.threedoob.objects.DisplayObject3D;
	import com.mrdoob.tools.threedoob.objects.DisplayObjectDof3D;
	import com.mrdoob.tools.threedoob.objects.Mesh3D;
	import com.mrdoob.tools.threedoob.scenes.Scene3D;
	import com.mrdoob.tools.threedoob.utils.arrayRemoveItemByInstance;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;	

	public class LayerRenderer extends AbstractRenderer
	{
		private var layers : Array;
		private var layerContainers : Array;
		
		public function LayerRenderer( layersCount : int = 1 )
		{
			super();
			
			layers = new Array();
			layerContainers = new Array();
			
			for (var i : int = 0; i < layersCount; i++)
			{
				layers[i] = new Array();
				layerContainers[i] = new Sprite();
				layerContainers[i].mouseEnabled = false;
				addChild( layerContainers[i] );
			}
		}

		public function onSceneUpdated( e : Scene3DEvent ) : void
		{
			var layer : int = e.item.layer;
			
			switch(e.type)
			{
				case Scene3DEvent.DISPLAYOBJECT3D_ADDED:
					layers[layer].push( e.item );
					layerContainers[layer].addChild(e.item.container);
					break;
				case Scene3DEvent.DISPLAYOBJECT3D_REMOVED:
					arrayRemoveItemByInstance( layers[layer], e.item );	
					layerContainers[layer].removeChild(e.item.container);
					break;
			}				
		}

		public override function sort(scene : Scene3D) : void
		{
			for (var i : int = 0; i < layers.length; i++)
			{
				layers[i].sortOn("sz", Array.DESCENDING | Array.NUMERIC);
	
				for (var j : int = 0; j < layers[i].length; j++)
					layerContainers[layers[i][j].layer].setChildIndex(layers[i][j].container, j);
			}
		}

		public override function render(scene : Scene3D, camera : Camera3D) : void
		{
			var v : Vertex3D, t : Triangle3D;
			var focus : Number = camera.focus;
			var focuszoom : Number = camera.focus * camera.zoom;	

			view.lookAt(camera, camera.target, camera.up);			

			for (var i : int = 0; i < scene.objects.length; i++)
			{
				if (scene.objects[i] is Mesh3D)
				{
					var mesh : Mesh3D = scene.objects[i];
					
					mesh.sz = mesh.x * view.n31 + mesh.y * view.n32 + mesh.z * view.n33 + view.n34;
					
					for (var j : int = 0; j < mesh.geometry.vertices.length; j++)
					{
						v = mesh.geometry.vertices[j];
						
						projected.x = v.x;
						projected.y = v.y;
						projected.z = v.z;
												
						//projected = mesh.transform.transform( projected );
						mesh.transform.transform( projected );
						
						v.sz = projected.x * view.n31 + projected.y * view.n32 + projected.z * view.n33 + view.n34;
						
						if (v.visible = (focus + v.sz > 0))
						{
							v.sx = projected.x * view.n11 + projected.y * view.n12 + projected.z * view.n13 + view.n14;
							v.sy = projected.x * view.n21 + projected.y * view.n22 + projected.z * view.n23 + view.n24;
							
							var ow : Number = focuszoom / (focus + v.sz);
							v.sx *= ow;
							v.sy *= -ow;
							v.sz *= ow;
						}
					}

					
					// Sort

					var renderList : Array = [];
					
					for (j = 0; j < mesh.geometry.triangles.length; j++)
					{	
						t = mesh.geometry.triangles[j];
						
						if (t.a.visible && t.b.visible && t.c.visible && (t.c.sx - t.a.sx) * (t.b.sy - t.a.sy) - (t.c.sy - t.a.sy) * (t.b.sx - t.a.sx) < 0 )
						{
							//t.sz = Math.max(t.a.sz, Math.max(t.b.sz, t.c.sz));
							t.sz = ( t.a.sz + t.b.sz + t.c.sz ) * 0.3;
							renderList.push( t );
						}
					}					
					
					renderList.sortOn("sz", Array.DESCENDING | Array.NUMERIC);
					
					
					// Render
					
					mesh.container.graphics.clear();

					for (j = 0; j < renderList.length; j++)
					{
						t = renderList[j];
						
						var x0 : Number = t.a.sx;
						var y0 : Number = t.a.sy;
						var x1 : Number = t.b.sx;
						var y1 : Number = t.b.sy;
						var x2 : Number = t.c.sx;
						var y2 : Number = t.c.sy;
		
						if ( mesh.material is ColorMaterial3D)
						{
							mesh.container.graphics.beginBitmapFill(mesh.material.bitmap);
						}						
						else if ( mesh.material is WireframeMaterial3D)
						{
							mesh.container.graphics.lineStyle(0, WireframeMaterial3D(mesh.material).color);
						}
						else if ( mesh.material is BitmapMaterial3D)
						{
							var w:Number = mesh.material.bitmap.width;
							var h:Number = mesh.material.bitmap.height;
							
							var u0:Number = renderList[j].uv[0].u * w;
							var v0:Number = renderList[j].uv[0].v * h;
							var u1:Number = renderList[j].uv[1].u * w;
							var v1:Number = renderList[j].uv[1].v * h;
							var u2:Number = renderList[j].uv[2].u * w;
							var v2:Number = renderList[j].uv[2].v * h;
							
							var sMat : Matrix = new Matrix();
							var tMat : Matrix = new Matrix();
							
							tMat.tx = u0;
							tMat.ty = v0;
							
							tMat.a = (u1 - u0) / w;
							tMat.b = (v1 - v0) / w;
							tMat.c = (u2 - u0) / h;
							tMat.d = (v2 - v0) / h;
							
							sMat.a = (x1 - x0) / w;
							sMat.b = (y1 - y0) / w;
							sMat.c = (x2 - x0) / h;
							sMat.d = (y2 - y0) / h;
							
							sMat.tx = x0;
							sMat.ty = y0;
							
							tMat.invert();
							tMat.concat(sMat);					
							
							mesh.container.graphics.beginBitmapFill(mesh.material.bitmap, tMat, true, BitmapMaterial3D(mesh.material).smoothing);
						}
						else
						{
							mesh.container.graphics.beginFill( t.sz );
						}
						
						mesh.container.graphics.moveTo(x0, y0);
						mesh.container.graphics.lineTo(x1, y1);
						mesh.container.graphics.lineTo(x2, y2);
						mesh.container.graphics.lineTo(x0, y0);
						mesh.container.graphics.endFill();
						
					}
					
				}
				else if (scene.objects[i] is DisplayObject3D)
				{
					var object : DisplayObject3D = scene.objects[i];
					
					object.sz = object.x * view.n31 + object.y * view.n32 + object.z * view.n33 + view.n34;
					
					if (object.container.visible = (focus + object.sz > 0))
					{
						ow = focuszoom / (focus + object.sz);

						object.container.x = (object.x * view.n11 + object.y * view.n12 + object.z * view.n13 + view.n14) * ow;
						object.container.y = (object.x * view.n21 + object.y * view.n22 + object.z * view.n23 + view.n24) * -ow;						
						object.container.scaleX =  ow * object.scaleX;
						object.container.scaleY =  ow * object.scaleY;
						
						// DOF
						
						if (scene.objects[i] is BitmapDof3D || scene.objects[i] is DisplayObjectDof3D )
							scene.objects[i].setBlur( Math.abs( 1.3 - ow ) );
															
					}			
				}				
			}
			
			//sort(scene);
			
		}		
	}
}