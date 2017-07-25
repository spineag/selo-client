package utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.rendering.Painter;
import starling.textures.RenderTexture;
import starling.textures.Texture;

public class DrawToBitmap {
    private static var g:Vars = Vars.getInstance();

    public static function copyToBitmapDataWithRectangle(starling:Starling, disp:DisplayObject, rect:Rectangle):BitmapData {
        var result:BitmapData = new BitmapData(rect.width, rect.height, true);
        var stage:Stage = g.mainStage;
        var painter:Painter = starling.painter;

        painter.pushState();
        painter.state.renderTarget = null;
        painter.state.setProjectionMatrix(rect.x, rect.y, stage.stageWidth, stage.stageHeight, stage.stageWidth, stage.stageHeight, stage.cameraPosition);
        painter.clear();
        disp.setRequiresRedraw();
        disp.render(painter);
        painter.finishMeshBatch();
        painter.context.drawToBitmapData(result);
        painter.context.present();
        painter.popState();

        return result;
    }

    public static function stageScreenShot():BitmapData {
        var stage:Stage = g.mainStage;
        var result:BitmapData = new BitmapData(stage.width, stage.height, true);
        stage.drawToBitmapData(result);
        return result;
    }

    public static function stageScreenShotByRect(rect:Rectangle):BitmapData {
        var stage:Stage = g.mainStage;
        var r:BitmapData = new BitmapData(stage.width, stage.height, true);
        stage.drawToBitmapData(r);
        var result:BitmapData = new BitmapData(rect.width, rect.height);
        result.copyPixels(r, rect, new Point(0, 0));
        return result;
    }

    public static function drawToBitmap(starling:Starling, displayObject:DisplayObject):Bitmap {
//        var resultBitmap:Bitmap = new Bitmap(copyToBitmapData(starling, displayObject));
        var resultBitmap:Bitmap = new Bitmap(copyToBitmapDataNew(starling, displayObject));
        return resultBitmap;
    }

    public static function copyToBitmapData(starling:Starling, disp:DisplayObject):BitmapData {
        var bounds:Rectangle = disp.getBounds(disp);
        var result:BitmapData = new BitmapData(bounds.width, bounds.height, true);
        var stage:Stage = g.mainStage;
        var painter:Painter = starling.painter;

        painter.pushState();
        painter.state.renderTarget = null;
        painter.state.setProjectionMatrix(bounds.x, bounds.y, stage.stageWidth, stage.stageHeight, stage.stageWidth, stage.stageHeight, stage.cameraPosition);
        painter.clear();
        disp.setRequiresRedraw();
        disp.render(painter);
        painter.finishMeshBatch();
        painter.context.drawToBitmapData(result);
        painter.context.present();
        painter.popState();

        return result;
    }

    public static function copyToBitmapDataNew(starling:Starling, disp:DisplayObject):BitmapData {
        return disp.drawToBitmapData();
    }

    public static function copyToBitmapDataFromFlashSprite(fsp:flash.display.Sprite, s:Number = 1):BitmapData {
        var m:Matrix = new Matrix();
        var bounds:Rectangle = fsp.getBounds(fsp);
        m.translate(-bounds.x, -bounds.y);
        if (s!=1) m.scale(s, s);
        var bd:BitmapData = new BitmapData(bounds.width*s, bounds.height*s);
        bd.draw(fsp, m);
        return bd;
    }

    public static function getTextureFromStarlingDisplayObject(disp:DisplayObject, scale:Number=1):Texture {
        var texture:RenderTexture = new RenderTexture(disp.width, disp.height, true, scale);
        texture.draw(disp);
        return texture;
    }

    public static function getBitmapFromTextureBitmapAndTextureXML(b:Bitmap, xml:XML, name:String):BitmapData {
        var resultBD:BitmapData;
        var xl:XML;
        for each (var prop:XML in xml.SubTexture) {
            if (prop.@name==name) {
                xl = prop;
                break;
            }
        }
        if (xl) {
            resultBD = new BitmapData(int(xl.@width), int(xl.@height));
            var m:Matrix = new Matrix();
            m.translate(-int(xl.@x), -int(xl.@y));
            resultBD.draw(b, m);
        }
        return resultBD;
    }

    public static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData {
        scale = Math.abs(scale);
        var width:int = (bitmapData.width * scale) || 1;
        var height:int = (bitmapData.height * scale) || 1;
        var transparent:Boolean = bitmapData.transparent;
        var result:BitmapData = new BitmapData(width, height, transparent);
        var matrix:Matrix = new Matrix();
        matrix.scale(scale, scale);
        result.draw(bitmapData, matrix);
        return result;
    }
    
}
}


