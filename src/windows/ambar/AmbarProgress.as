/**
 * Created by user on 6/26/15.
 */
package windows.ambar {
import flash.geom.Rectangle;
import manager.Vars;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import utils.DrawToBitmap;
import utils.MCScaler;
import windows.WOComponents.ProgressBarComponent;

public class AmbarProgress {
    public var source:Sprite;
    private var _bar:ProgressBarComponent;
    private var imAmbar:Image;
    private var imSklad:Image;

    private var g:Vars = Vars.getInstance();

    public function AmbarProgress(addImages:Boolean = true) {
        source = new Sprite();
        source.touchable = false;
        createBG();
        source.alignPivot();
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 400);
        _bar.x = 14-4;
        _bar.y = 8-4;
        source.addChild(_bar);

        if (addImages) {
            imAmbar = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
            MCScaler.scale(imAmbar, 50, 50);
            imAmbar.alignPivot();
            imAmbar.x = 435;
            imAmbar.y = 19;
            source.addChild(imAmbar);
            imSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
            MCScaler.scale(imSklad, 46, 46);
            imSklad.alignPivot();
            imSklad.x = 432;
            imSklad.y = 20;
            source.addChild(imSklad);
        }
    }

    private function createBG():void {
        var sp:Sprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_bg_progres_bar'));
        im.x = -6;
        im.y = -4;
        sp.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_bg_progres_bar'));
        im.scaleX = -1;
        im.x = 441;
        im.y = -4;
        sp.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_bg_progres_bar_center'));
        im.tileGrid = new Rectangle();
        im.width = 435 - 2*14;
        im.x = 14;
        im.y = -4;
        im.tileGrid = im.tileGrid;
        sp.addChild(im);
        var sp2:Sprite = new Sprite();
        sp.x = 6;
        sp.y = 4;
        sp2.addChild(sp);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(sp2));
        im.x = -6;
        im.y = -4;
        source.addChild(im);
        sp2.dispose();
    }

    public function setProgress(a:Number):void {
        _bar.progress = a;
        var tween:Tween;
        if (imAmbar && imAmbar.visible) tween = new Tween(imAmbar, 0.6);
        else tween = new Tween(imSklad, 0.6);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.5);
        g.starling.juggler.add(tween);
    }

    public function showAmbarIcon(v:Boolean):void {
        imAmbar.visible = v;
        imSklad.visible = !v;
    }

    public function deleteIt():void {
        source.removeChild(_bar);
        _bar.deleteIt();
        _bar = null;
        source.dispose();
        source = null;
    }
}
}
