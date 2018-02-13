/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import announcement.ManagerAnnouncement;

import data.BuildType;
import data.DataMoney;
import data.StructureDataAnimal;

import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;
import manager.ManagerFilters;
import manager.ManagerWallPost;
import media.SoundConst;

import social.SocialNetworkSwitch;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.TutsAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SimpleArrow;
import utils.Utils;

import windows.WOComponents.BackgroundYellowOut;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOLevelUp extends WindowMain {

    private var _txtNewLvl:CTextField;
    private var _txtNewObject:CTextField;
    private var _txtLevel:CTextField;
    private var _txtGift:CTextField;
    private var _contBtn:CButton;
    private var _contImage:Sprite;
    private var _contImageGift:Sprite;
    private var _count:int;
    private var _contClipRect:Sprite;
    private var _contClipRectGift:Sprite;
    private var _arrCells:Array;
    private var _arrCellsGift:Array;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _arrItems:Array;
    private var _shift:int;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _bigYellowBGGift:BackgroundYellowOut;
    private var _bgCheck:CSprite;
    private var _imCheck:Image;
    private var _sprShare:CSprite;
    private var _sorceMainItem:Sprite;
    private var _bolShare:Boolean;
    private var _arrow:SimpleArrow;

    public function WOLevelUp() {
        super ();
        SOUND_OPEN = SoundConst.LEVEL_COMPLETED;
        _windowType = WindowsManager.WO_LEVEL_UP;
        if (g.managerResize.stageHeight < 750) _isBigWO = false;  else _isBigWO = true;
        if (!_isBigWO) _source.scale = .7;
        _woWidth = 745;
        _woHeight = 409;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/windows_new_level.png', onLoad);
        _arrCells = [];
        _arrCellsGift = [];
        _arrItems = [];
        _bolShare = true;
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/windows_new_level.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var im:Image;
        im = new Image(tex);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _count = 1;
        _txtNewLvl = new CTextField(500,100,String(g.managerLanguage.allTexts[420]));
        _txtNewLvl.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtNewLvl.leading = -3;
        _txtNewLvl.x = -220;
        _txtNewLvl.y = -220;
        _source.addChild(_txtNewLvl);

        _txtLevel = new CTextField(300,150,"");
        _txtLevel.setFormat(CTextField.BOLD72, 72, 0xf77a3f, Color.WHITE);
        _txtLevel.x = -130;
        _txtLevel.y = -360;
        _source.addChild(_txtLevel);

        createArrow();
        _callbackClickBG = null;

        if (g.user.level >= 11) g.couponePanel.openPanel(true);
        _txtLevel.text = String(g.user.level);
        createList();
        _source.y -= 40;
    }

    private function shareClick():void {
        _bolShare = !_bolShare;
        _imCheck.visible = _bolShare;
        if (_bolShare) {
            _contBtn.clickCallback = onClickShare;

        } else {
            _contBtn.clickCallback = onClickNext;
        }
    }

    private function createArrow():void {
        var im:Image;
        _leftArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.x = im.width;
        _leftArrow.addDisplayObject(im);
        _leftArrow.setPivots();
        _leftArrow.x = -280;
        _leftArrow.y = 55 + _leftArrow.height/2;
        _source.addChild(_leftArrow);
        _leftArrow.clickCallback = onLeftClick;

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX *= -1;
        _rightArrow.addDisplayObject(im);
        _rightArrow.setPivots();
        _rightArrow.x = 324;
        _rightArrow.y = 55 + _rightArrow.height/2;
        _source.addChild(_rightArrow);
        _rightArrow.clickCallback = onRightClick;
    }

    private function createMain(countArr:int = 0, arrGift:int = 0):void {
        _sorceMainItem = new Sprite();
        _source.addChild(_sorceMainItem);
        var widthYellow:int = 0;
        if (countArr >= 3) {
            widthYellow = 540;
        } else if (countArr == 2) {
            widthYellow = 367;
        } else {
            widthYellow = 184;
        }
        var im:Image;
        _bigYellowBG = new BackgroundYellowOut(widthYellow, 240);
        _sorceMainItem.addChild(_bigYellowBG);

        _txtNewObject = new CTextField(400,100,String(g.managerLanguage.allTexts[421]));
        _txtNewObject.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_LIGHT_NEW);
        _txtNewObject.x = -170;
        _sorceMainItem.addChild(_txtNewObject);

        _contClipRect = new Sprite();
        _contClipRect.mask = new Quad(519,500);
        _sorceMainItem.addChild(_contClipRect);

        _bgCheck = new CSprite();
        _source.addChild(_bgCheck);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shared'));
        _bgCheck.addChild(im);
        _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
        _bgCheck.addChild(_imCheck);
        MCScaler.scale(_imCheck, _imCheck.height-7,_imCheck.width-7);
        _imCheck.x = -3;
        _imCheck.y = -11;
        _bgCheck.x = -195;
        _bgCheck.endClickCallback = shareClick;
        if (countArr >= 3) {
            _bigYellowBG.x = -_woWidth/2 + 125;
            _contClipRect.x = -_woWidth/2 + 135;
        } else if (countArr == 2) {
            _bigYellowBG.x = -155;
            _contClipRect.x = -145
        } else {
            _bigYellowBG.x = -55;
            _contClipRect.x = -50;
        }
        _sprShare = new CSprite();
        _source.addChild(_sprShare);
        var txtShare:CTextField;
        txtShare = new CTextField(300,100,String(g.managerLanguage.allTexts[291]));
        txtShare.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_LIGHT_NEW);
        txtShare.x = -250;
        txtShare.touchable = true;
        _sprShare.addChild(txtShare);
        _sprShare.endClickCallback = shareClick;


        _contBtn = new CButton();
        _contBtn.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
        _contBtn.addTextField(100, 40, -5, -2, String(g.managerLanguage.allTexts[328]));
        _contBtn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_contBtn);
        if (g.user.level > 3) _contBtn.clickCallback = onClickShare;
        else _contBtn.clickCallback = onClickNext;
        _contBtn.x = 40;

        if (arrGift > 0) {
            _bigYellowBG.y = -12;
            _contClipRect.y = 0;
            _txtNewObject.y = -85;
            _contBtn.y = _woHeight/2 + 50;
            _bgCheck.y = 240;
            _sprShare.y = 198;

        } else {
            _bigYellowBG.y = -60;
            _contClipRect.y = -45;
            _txtNewObject.y = -135;
            _contBtn.y = _woHeight/2 + 23;
            _bgCheck.y = 220;
            _sprShare.y = 178;
        }
        _contImage = new Sprite();
        _contClipRect.addChild(_contImage);
        if (g.user.level <= 3) {
            _sprShare.visible = false;
            _bgCheck.visible = false;
        }
    }

    private function createGiftSource():void {
        _bigYellowBGGift = new BackgroundYellowOut(540, 50);
        _bigYellowBGGift.x = -_woWidth/2 + 125;
        _bigYellowBGGift.y = -110;
        _source.addChild(_bigYellowBGGift);

        _contClipRectGift = new Sprite();
        _source.addChild(_contClipRectGift);
        _contClipRectGift.mask = new Quad(600,50);
        _contClipRectGift.x = -_woWidth/2 + 205;
        _contClipRectGift.y = -100;
        _contImageGift = new Sprite();
        _contClipRectGift.addChild(_contImageGift);
        _txtGift = new CTextField(110,100,String(g.managerLanguage.allTexts[363]));
        _txtGift.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtGift.x = -239;
        _txtGift.y = -135;
        _source.addChild(_txtGift);
    }

    override public function showItParams(callback:Function, params:Array):void {
        g.friendPanel.hideIt(true);
        g.craftPanel.hideIt();
        _shift = 0;
        if (g.user.level <= 3) {
            var f1:Function = function ():void {
                addArrow();
            };
            Utils.createDelay(3,f1);
        }
        super.showIt();
    }
    
    private function onClickNext():void {
        hideIt();
    }

    override public function hideIt():void {
        super.hideIt();
        if (g.user.level == 4) {
            var arr:Array = g.townArea.getCityObjectsByType(BuildType.ORDER);
            arr[0].showArrow(120);
        }
        if (g.user.level > 3 && g.user.isOpenOrder && !g.isAway) g.managerOrder.checkOrders();
//        if (g.user.level == 8) g.windowsManager.openWindow(WindowsManager.WO_DAILY_BONUS,null);
    }

    private function onLeftClick():void {
        _shift -= 5;
        if (_shift < 0) _shift = 0;
        animList();
        checkBtns();
    }

    private function onRightClick():void {
        _shift += 5;
        if (_shift > int(_arrCells.length - 3)) _shift = int(_arrCells.length - 3);
        animList();
        checkBtns();
    }

    private function checkBtns():void {
        if (_arrCells.length > 3) {
            if (_shift <= 0) {
                _leftArrow.setEnabled = false;
            } else {
                _leftArrow.setEnabled = true;
            }
            if (_shift + 3 >= _arrCells.length) {
                _rightArrow.setEnabled = false;
            } else {
                _rightArrow.setEnabled = true;
            }
        }
    }

    private function animList():void {
        var tween:Tween = new Tween(_contImage, .5);
        tween.moveTo(-_shift*173,50);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
    }

    private function createList():void {
        var arR:Array;
        var objDataLevel:Object;
        var arr:Array;
        var im:WOLevelUpItem;
        var i:int;
        var k:int;
        var arGift:Array = [];
        _leftArrow.visible = false;
        _rightArrow.visible = false;
        arr = [];
        arR = g.allData.resource;
        for (i=0; i<arR.length; i++) {
            if (arR[i].buildType == BuildType.INSTRUMENT) continue;
            if (g.user.level == arR[i].blockByLevel) {
                objDataLevel = {};
                objDataLevel.id = arR[i].id;
                objDataLevel.blockByLevel = arR[i].blockByLevel;
                objDataLevel.priceHard = arR[i].priceHard;
                objDataLevel.name = arR[i].name;
                objDataLevel.image = arR[i].image;
                objDataLevel.url = arR[i].url;
                objDataLevel.imageShop = arR[i].imageShop;
                objDataLevel.currency = arR[i].currency;
                objDataLevel.costDefault = arR[i].costDefault;
                objDataLevel.costMax = arR[i].costMax;
                objDataLevel.orderPrice = arR[i].orderPriceMin;
                objDataLevel.orderXP = arR[i].orderXPMin;
                objDataLevel.visitorPrice = arR[i].visitorPrice;
                objDataLevel.buildType = arR[i].buildType;
                objDataLevel.placeBuild = arR[i].placeBuild;
                objDataLevel.orderType = arR[i].orderType;
                objDataLevel.opys = arR[i].opys;
                objDataLevel.priceSkipHard = arR[i].priceSkipHard;
                objDataLevel.buildTime = arR[i].buildTime;
                objDataLevel.craftXP = arR[i].craftXP;
                objDataLevel.priority = 10;
                arr.push(objDataLevel);
                if (arR[i].buildType == BuildType.PLANT) {
                    objDataLevel = {};
                    objDataLevel.id = arR[i].id;
                    objDataLevel.count = 3;
                    objDataLevel.resourceData = 4;
                    arGift.push(objDataLevel);
                }
            }
        }
        arR = g.allData.building;
        var b:Boolean = true;
        var j:int = 0;
        for (i = 0; i < arR.length; i++) {
            if (arR[i].buildType != BuildType.CHEST) {
                if (arR[i].buildType == BuildType.TREE || arR[i].buildType == BuildType.FARM || arR[i].buildType == BuildType.FABRICA) {
                    for (k = 0; k < arR[i].blockByLevel.length; k++) {
                        if (g.user.level == arR[i].blockByLevel[k]) {

                            objDataLevel = {};
                            objDataLevel = Utils.objectFromStructureBuildToObject(arR[i]);
                            objDataLevel.priority = 15;
                            arr.push(objDataLevel);
                        }
                    }
                } else if (g.user.level == arR[i].blockByLevel && arR[i].visibleAction) {
                    objDataLevel = {};
                    objDataLevel = Utils.objectFromStructureBuildToObject(arR[i]);
                    b = true;
                    if (arR[i].buildType != BuildType.CAVE && arR[i].buildType != BuildType.TRAIN && arR[i].buildType != BuildType.PAPER && arR[i].buildType != BuildType.DAILY_BONUS
                            && arR[i].buildType != BuildType.ORDER && arR[i].buildType != BuildType.MARKET) {
                        objDataLevel.priority = 25;
                    } else objDataLevel.priority = 15;
                    if (b) arr.push(objDataLevel);
                }
            }
        }

        if (g.dataLevel.objectLevels[g.user.level].countHard > 0) {
            objDataLevel = {};
            objDataLevel.hard = true;
            objDataLevel.countHard = g.dataLevel.objectLevels[g.user.level].countHard;
            objDataLevel.priority = 0;
            arGift.push(objDataLevel);
        }
        if (g.dataLevel.objectLevels[g.user.level].countSoft > 0) {
            objDataLevel = {};
            objDataLevel.coins = true;
            objDataLevel.countSoft = g.dataLevel.objectLevels[g.user.level].countSoft;
            objDataLevel.priority = 1;
            arGift.push(objDataLevel);
        }

        if (g.dataLevel.objectLevels[g.user.level].decorId[0] > 0) {
            for (i = 0; i < g.dataLevel.objectLevels[g.user.level].decorId.length; i++) {
                j = g.dataLevel.objectLevels[g.user.level].decorId[i];
                if (j != 114 && j != 115 && j != 116 && j != 117
                        && j != 118 && j != 177 && j != 178 && j != 179
                        && j != 109 && j != 112 && j != 111 && j != 110
                        && j != 107 && j != 208 && j != 206 && j != 207) {
                    objDataLevel = {};
                    objDataLevel.decorData = true;
                    objDataLevel.count = g.dataLevel.objectLevels[g.user.level].countDecor[i];
                    objDataLevel.priority = 30;
                    objDataLevel = Utils.objectFromStructureBuildToObject(objDataLevel.id = g.dataLevel.objectLevels[g.user.level].decorId[i]);
                    arr.push(objDataLevel);
                }
            }
        }
        if (g.dataLevel.objectLevels[g.user.level].ridgeCount > 0) {
            objDataLevel = {};
            objDataLevel.ridge = true;
            objDataLevel = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(11));
            objDataLevel.count = g.dataLevel.objectLevels[g.user.level].ridgeCount;
            objDataLevel.priority = 5;
            arr.push(objDataLevel);
        }
        if (g.dataLevel.objectLevels[g.user.level].resourceId[0] > 0) {
            b = false;
            for (i = 0; i < g.dataLevel.objectLevels[g.user.level].resourceId.length; i++) {
               for (j = 0; j < arr.length; j++) {
                   if (arr[j].id && arr[j].id == g.dataLevel.objectLevels[g.user.level].resourceId[i]) {
                       b = true;
                       break;
                   }
               }
                if (!b) {
                    objDataLevel = {};
                    objDataLevel.resourceData = true;
                    objDataLevel.id = g.dataLevel.objectLevels[g.user.level].resourceId[i];
                    objDataLevel.count = g.dataLevel.objectLevels[g.user.level].countResource[i];
                    objDataLevel.priority = 3;
                    arGift.push(objDataLevel);
                } else {
                    arr.splice(j,1);
                    objDataLevel = {};
                    objDataLevel.resourceData = true;
                    objDataLevel.id = g.dataLevel.objectLevels[g.user.level].resourceId[i];
                    objDataLevel.count = g.dataLevel.objectLevels[g.user.level].countResource[i] + 3;
                    objDataLevel.priority = 3;
                    arGift.push(objDataLevel);
                }
            }
        }
        var animal:StructureDataAnimal;
        if (arGift.length > 0) {
            createGiftSource();
            arGift.sortOn("priority", Array.NUMERIC);
            var itemGift:WOLevelUpGift;
            _arrCellsGift = [];
            for (i = 0; i < arGift.length; i++) {
                itemGift = new WOLevelUpGift(arGift[i],true, true, 3);
                if (i > 0) itemGift.source.x = 38 + int(i) * (_arrCellsGift[i-1].widthSource);
                else itemGift.source.x = 38 + int(i);
                _arrCellsGift.push(itemGift);
                _contImageGift.addChild(itemGift.source);
                _contImageGift.y = 2;
            }
        }
        createMain(arr.length, arGift.length);
        arr.sortOn("priority", Array.NUMERIC);
        _arrItems = [];
        _arrCells = [];
        for (i = 0; i < arr.length; i++) {
            if (arr[i].buildType == BuildType.FARM) {
                animal = g.allData.getAnimalByFarmId(arr[i].id);
                if (animal) arr.push(animal);
            }
            _arrItems.push(arr[i]);
            im = new WOLevelUpItem(arr[i],true, true, 3);
            im.source.x = 38 + int(i) * (173);
            _arrCells.push(im);
            _contImage.addChild(im.source);
            _contImage.y = 50;
        }
        if (_arrCells.length > 3) {
            if (_arrCellsGift && _arrCellsGift.length > 0) {
                _leftArrow.y = 55 + _leftArrow.height/2;
                _rightArrow.y = 55 + _rightArrow.height/2;
            } else {
                _leftArrow.y = 15 + _leftArrow.height/2;
                _rightArrow.y = 15 + _rightArrow.height/2;
            }
            _leftArrow.visible = true;
            _leftArrow.setEnabled = false;
            _rightArrow.visible = true;
        }
//        MCScaler.scale(_source,_source.height - 200, _source.width-200);
    }

    private function onClickShare():void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        g.managerWallPost.postWallpost(ManagerWallPost.NEW_LEVEL,null,_count,DataMoney.HARD_CURRENCY);
        hideIt();
    }

    override protected function deleteIt():void {
        g.levelUpHint.hideIt();
        if (g.tuts.isTuts && g.tuts.action == TutsAction.LEVEL_UP) {
            g.tuts.checkTutsCallback();
        }
        g.managerCutScenes.checkCutScene(ManagerCutScenes.REASON_NEW_LEVEL);
        if (g.user.level == 3 || g.user.level == 4) g.miniScenes.checkAvailableMiniScenesOnNewLevel();

        if (g.user.level == 4) {
            g.managerQuest.addUI();
            g.managerAnnouncement = new ManagerAnnouncement();
        } else if (g.user.level > 4) {
            g.managerQuest.getNewQuests();
        }
        if (_txtNewLvl) {
            _source.removeChild(_txtNewLvl);
            _txtNewLvl.deleteIt();
            _txtNewLvl = null;
        }
        if (_txtNewObject) {
            _source.removeChild(_txtNewObject);
            _txtNewObject.deleteIt();
            _txtNewObject = null;
        }
        if (_txtLevel) {
            _source.removeChild(_txtLevel);
            _txtLevel.deleteIt();
            _txtLevel = null;
        }
        if (_arrCells) {
            for (var i:int = 0; i < _arrCells.length; i++) {
                _arrCells[i].deleteIt();
            }
            _arrCells.length = 0;
        }
        if (_contBtn) {
            _source.removeChild(_contBtn);
            _contBtn.deleteIt();
            _contBtn = null;
        }
        if (_leftArrow) {
            _source.removeChild(_leftArrow);
            _leftArrow.deleteIt();
            _leftArrow = null;
        }
        if (_rightArrow) {
            _source.removeChild(_rightArrow);
            _rightArrow.deleteIt();
            _rightArrow = null;
        }
        super.deleteIt();
    }

    public function addArrow():void {
        if (_contBtn && !_arrow) {
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _source);
            _arrow.animateAtPosition(_contBtn.x, _contBtn.y + _contBtn.height/2 - 2);
            _arrow.scaleIt(.7);
        }
    }

    public function hideArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

}
}
