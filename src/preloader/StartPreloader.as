/**
 * Created by user on 7/16/15.
 */
package preloader {
import flash.display.Bitmap;
import loaders.PBitmap;
import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetwork;
import social.SocialNetworkSwitch;
import social.fb.SN_FB;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;

public class StartPreloader {
    [Embed(source="../../assets/embeds/fb_back_new.jpg")]
    private const BigBackground:Class;

    private var _source:Sprite;
    private var _bg:Image;
    private var _progresBar:Image;
    private var _txt:CTextField;
    private var _txtHelp:CTextField;
    private var _jpgUrl:String;
    private var _callbackInit:Function;
    private var _whiteQuad:Quad;
    private var _whiteShift:int = 2;
    private var _bigBG:Image;
    private var _curProgress:int;

    private var g:Vars = Vars.getInstance();

    public function StartPreloader(f:Function) {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID && !g.isDebug) g.socialNetwork.JSflashConsole('startPreloader init class');
        var arBGs:Array;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) arBGs = ['list_of_tips_decor_eng', 'list_of_tips_farm_stand_eng', 'list_of_tips_inventory_eng', 'list_of_tips_barn_eng', 'list_of_tips_order_eng', 'list_of_tips_silo_eng'];
            else arBGs = ['list_of_tips_decor_rus', 'list_of_tips_farm_stand_rus', 'list_of_tips_inventory_rus', 'list_of_tips_barn_rus', 'list_of_tips_order_rus', 'list_of_tips_silo_rus'];
        _jpgUrl = g.dataPath.getGraphicsPath() + 'preloader/' + arBGs[int(Math.random()*arBGs.length)] + '.jpg';
        _callbackInit = f;
        _source = new Sprite();
        _txt = new CTextField(75,60,'0');
        _txt.setFormat(CTextField.BOLD30, 26,Color.WHITE, 0x0659b6);
        _txt.x = 460;
        _txt.y = 575;
        _txt.visible = false;
        addBG();
        onResize();
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'preloader/progres_bar_splash_screen.png', onLoadScreen);
    }

    private function addBG():void {
        var b:Bitmap = new BigBackground();
        _bigBG = new Image(Texture.fromBitmap(b));
        _bigBG.x = 500 - _bigBG.width/2;
        _bigBG.y = 320 - _bigBG.height/2;
        _source.addChildAt(_bigBG, 0);
        g.cont.popupCont.addChild(_source);
        g.pBitmaps['bigBG'] = new PBitmap(b);
    }

    private function onLoadScreen(b:Bitmap):void {
        _progresBar = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'preloader/progres_bar_splash_screen.png'].create() as Bitmap));
        _progresBar.x = 340;
        _progresBar.y = 589;
        g.load.loadImage(_jpgUrl, onLoad);
    }

    private function onLoad(b:Bitmap):void {
        _whiteQuad = new Quad(1000 + 2*_whiteShift, 640 + 2*_whiteShift, Color.WHITE);
        _whiteQuad.x = -_whiteShift;
        _whiteQuad.y = -_whiteShift;
        _source.addChildAt(_whiteQuad, 1);
        if (g.pBitmaps[_jpgUrl]) {
            _bg = new Image(Texture.fromBitmap(g.pBitmaps[_jpgUrl].create() as Bitmap));
            _source.addChildAt(_bg, 2);
        }
        _source.addChild(_progresBar);
        _source.addChild(_txt);
        if (g.pBitmaps[_jpgUrl]) {
            (g.pBitmaps[_jpgUrl] as PBitmap).deleteIt();
            delete g.pBitmaps[_jpgUrl];
        }
        g.load.removeByUrl(_jpgUrl);
        _txt.visible = true;
        onResize();
        if (_callbackInit != null) {
            _callbackInit.apply();
            _callbackInit = null;
        }
    }

    public function setProgress(a:int):void {
        _curProgress = a;
        if (_progresBar) _progresBar.width = a*3.2;
        if (_txt) _txt.text = String(a + '%');
    }
    
    public function get progress():int { return _curProgress; }

    public function onResize():void {
        if (!_source || !g.managerResize) return;
        _source.x = g.managerResize.stageWidth/2 - 500;
        _source.y = g.managerResize.stageHeight/2 - 320;
    }

    public function textHelp(str:String):void {
        _txtHelp = new CTextField(1000, 640,str);
        _txtHelp.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtHelp.y = 275;
        _source.addChild(_txtHelp);
    }

    public function hideIt():void {
        if (!_source) return;
        if (_source) {
            g.cont.popupCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
        }
        if (_txt) _txt.deleteIt();
        if (_txtHelp) _txtHelp.deleteIt();
        if (_bg)_bg.dispose();
        if (_bigBG) _bigBG.dispose();
        if (_whiteQuad) _whiteQuad.dispose();
        _source.dispose();
        _source = null;
    }
}
}
