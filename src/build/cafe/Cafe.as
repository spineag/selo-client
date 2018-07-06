/**
 * Created by user on 9/12/16.
 */
package build.cafe {
import build.WorldObject;

import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import flash.geom.Point;

import hint.FlyMessage;

import loaders.PBitmap;

import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;

import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.CSprite;
import utils.MCScaler;

import windows.WindowsManager;

public class Cafe extends WorldObject {

    private var _isHover:Boolean;
    private var _spriteFirst:CSprite;
    private var _spriteSecond:CSprite;
    private var _spriteThird:CSprite;
    private var _imDoor:Image;
    private var _imLeftWindow:Image;
    private var _imRightWindow:Image;
    private var _imMenu:Image;
    private var _imBigTree:Image;
    private var count:int = 0;
    private var _csprMenu:CSprite;
    private var _imFence1:Image;
    private var _imFence2:Image;
    private var _imFence3:Image;
    private var _imFence4:Image;
    private var _imFence6:Image;
    private var _imFence7:Image;
    private var _imFlowerS1:Image;
    private var _imFlowerS2:Image;
    private var _imFlowerR1:Image;
    private var _imFlowerR3:Image;

    private var _imTable1:Image;

    public function Cafe(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Cafe');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Cafe');
            return;
        }
        useIsometricOnly = false;
        _spriteSecond = new CSprite();
        _spriteThird = new CSprite();
        _spriteFirst = new CSprite();
        _csprMenu = new CSprite();
        _spriteSecond.releaseContDrag = true;
        _spriteThird.releaseContDrag = true;
        _spriteFirst.releaseContDrag = true;
        _csprMenu.releaseContDrag = true;
        _source.addChild(_spriteFirst);
        _source.addChild(_spriteSecond);
        _source.addChild(_spriteThird);
        if (!g.allData.atlas['cafeAtlas']) atlasLoad();
        _source.releaseContDrag = true;
        _dbBuildingId = _data.dbId;
        _isHover = false;
    }


    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['cafeAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'cafeAtlas.png' + g.getVersion('cafeAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'cafeAtlas.xml' + g.getVersion('cafeAtlas'), onLoad);
        }
    }

    private function createAtlases():void {
        var url:String = g.dataPath.getGraphicsPath() + 'cafeAtlas.png' + g.getVersion('cafeAtlas');
        var urlXML:String = g.dataPath.getGraphicsPath() + 'cafeAtlas.xml' + g.getVersion('cafeAtlas');
        g.allData.atlas['cafeAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[url].create() as Bitmap), g.pXMLs[urlXML]);
        (g.pBitmaps[url] as PBitmap).deleteIt();
        delete  g.pBitmaps[url];
        delete  g.pXMLs[urlXML];
        g.load.removeByUrl(url);
        g.load.removeByUrl(urlXML);
        createImage();
    }

    private function createImage():void {
        _imDoor = new Image(g.allData.atlas['cafeAtlas'].getTexture('door_1'));
        _imLeftWindow = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_left'));
        _imRightWindow = new Image(g.allData.atlas['cafeAtlas'].getTexture('window_right'));
        _imMenu = new Image(g.allData.atlas['cafeAtlas'].getTexture('board_1'));
        _imBigTree = new Image(g.allData.atlas['cafeAtlas'].getTexture('tree_1'));
        _imFence1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_1'));
        _imFence2 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_2'));
        _imFence3 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_2'));
        _imFence4 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_4'));
        _imFence6 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_6'));
        _imFence7 = new Image(g.allData.atlas['cafeAtlas'].getTexture('part_7'));
        _imFlowerS1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_1'));
        _imFlowerS2 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_1'));
        _imFlowerR1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_3'));
        _imFlowerR3 = new Image(g.allData.atlas['cafeAtlas'].getTexture('plant_3'));
        _imTable1 = new Image(g.allData.atlas['cafeAtlas'].getTexture('table_cafe_3'));
        MCScaler.scale(_imTable1, _imTable1.height/1.5, _imTable1.width/1.5);
        _imLeftWindow.x = -90;
        _spriteFirst.addChild(_imLeftWindow);

        _imRightWindow.x = 140;
        _imRightWindow.y = 27;
        _spriteFirst.addChild(_imRightWindow);
        _imDoor.x = -40;
        _imDoor.y = 6;
        _spriteFirst.addChild(_imDoor);

        _imBigTree.y = -332;
        _imBigTree.x = -75;
        _spriteFirst.addChild(_imBigTree);

        _imFence1.x = -172;
        _imFence1.y = 88;
        _spriteFirst.addChild(_imFence1);

        _imFence2.x = -167;
        _imFence2.y = 124;
        _spriteThird.addChild(_imFence2);

        _imFence3.x = 47;
        _imFence3.y = 232;
        _spriteThird.addChild(_imFence3);

        _imFence4.x = 174;
        _imFence4.y = 211;
        _spriteThird.addChild(_imFence4);

        _imFence7.x = 282;
        _imFence7.y = 140;
        _spriteFirst.addChild(_imFence7);

        _imTable1.x = 166;
        _imTable1.y = 140;
        _spriteSecond.addChild(_imTable1);

        _imFlowerS1.x = -151;
        _imFlowerS1.y = 70;
        _spriteSecond.addChild(_imFlowerS1);

        _imFlowerS2.x = 158;
        _imFlowerS2.y = 224;
        _spriteSecond.addChild(_imFlowerS2);

        _imFlowerR1.x = 63;
        _imFlowerR1.y = 165;
        _spriteSecond.addChild(_imFlowerR1);

        _imFlowerR3.x = 337;
        _imFlowerR3.y = 114;
        _spriteSecond.addChild(_imFlowerR3);

        _imFence6.x = 336;
        _imFence6.y = 188;
        _spriteSecond.addChild(_imFence6);

        _csprMenu.x = -75;
        _csprMenu.y = 105;
        _spriteThird.addChild(_csprMenu);
        _csprMenu.addChild(_imMenu);
        _csprMenu.endClickCallback = onClickM;
        _csprMenu.hoverCallback = onHoverMenu;
        _csprMenu.outCallback = onOutMenu;
        _spriteFirst.endClickCallback = onClickMenu;
        _spriteFirst.hoverCallback = onHoverMenu;
        _spriteFirst.outCallback = onOutMenu;
        _spriteSecond.endClickCallback = onClickMenu;
        _spriteSecond.hoverCallback = onHoverMenu;
        _spriteSecond.outCallback = onOutMenu;
        _spriteThird.endClickCallback = onClickMenu;
        _spriteThird.hoverCallback = onHoverMenu;
        _spriteThird.outCallback = onOutMenu;
    }

    private function onClickM():void {
        g.soundManager.playSound(SoundConst.EMPTY_CLICK);
        var p:Point = new Point(_source.x, _source.y + 10);
        p = _source.parent.localToGlobal(p);
        new FlyMessage(p,String(g.managerLanguage.allTexts[1290]));
//        g.windowsManager.openWindow(WindowsManager.WO_CAFE_RATING, null);
    }

    private function onClickMenu():void {
        _csprMenu.filter = null;
        _isHover = false;
        g.soundManager.playSound(SoundConst.EMPTY_CLICK);
        var p:Point = new Point(_source.x, _source.y + 10);
        p = _source.parent.localToGlobal(p);
        new FlyMessage(p,String(g.managerLanguage.allTexts[1290]));
//        g.windowsManager.openWindow(WindowsManager.WO_CAFE, null);
    }

    private function onHoverMenu():void {
        if (_isHover) return;
        _isHover = true;
        _csprMenu.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _spriteFirst.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _spriteSecond.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _spriteThird.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOutMenu():void {
        _isHover = false;
        _csprMenu.filter = null;
        _spriteFirst.filter = null;
        _spriteSecond.filter = null;
        _spriteThird.filter = null;
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
//        if (_isHover) return;
//        super.onHover();
//        _isHover = true;
//        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
//        super.onOut();
//        _isHover = false;
//        g.hint.hideIt();
    }

    private function onClick():void {
//        var p0:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
//        p0.y -= 50;
//        g.soundManager.playSound(SoundConst.EMPTY_CLICK);
//        new FlyMessage(p0,"Скоро будет!!!");
        if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_BUY_CAVE, null, _dataBuild, "Откройте поезд", 'house');

    }
}
}
