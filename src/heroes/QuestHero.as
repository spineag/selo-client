/**
 * Created by user on 9/23/15.
 */
package heroes {

import build.TownAreaBuildSprite;
import build.WorldObject;
import build.decor.DecorAnimation;
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.ridge.Ridge;
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;

import data.BuildType;

import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;

import hint.FlyMessage;

import media.SoundConst;

import order.DataOrderCat;

import order.ManagerOrder;

import order.OrderCat;
import order.OrderItemStructure;

import starling.display.Image;
import starling.display.Sprite;

import tutorial.TutorialTextBubble;

import utils.CSprite;
import utils.Utils;

public class QuestHero extends BasicCat{
    private var _catImage:CSprite;
    private var _catBackImage:CSprite;
    private var _isFree:Boolean;
    private var _id:int;
    private var _decorAnimation:DecorAnimation;
    private var freeIdleGo:Boolean;
    private var _animation:HeroCatsAnimation;
    private var _isRandomWork:Boolean;
    private var _bubble:TutorialTextBubble;
    private var _isFlip:Boolean;
    public var bShowBubble:Boolean;
    private var _dataCats:Object;
    private var _bable:Bone;
    private var _timer:int;

    public function QuestHero(id:int) {
        super();
        _isRandomWork = false;
        _dataCats = DataOrderCat.getCatObjById(id);
        _id = id;
        _isFree = true;
        timer = 0;
        _source = new TownAreaBuildSprite();
//        _source.touchable = false;
        _catImage = new CSprite();
        _catImage.endClickCallback = onClick;

        _catBackImage = new CSprite();
        _catBackImage.endClickCallback = onClick;
        freeIdleGo = true;
        bShowBubble = false;
        _animation = new HeroCatsAnimation();
        _animation.catArmature = g.allData.factory['cat_queue'].buildArmature("cat");
        _animation.catBackArmature = g.allData.factory['cat_queue'].buildArmature("cat_back");
        _catImage.addChild(_animation.catArmature.display as StarlingArmatureDisplay);
        _catBackImage.addChild(_animation.catBackArmature.display as StarlingArmatureDisplay);

        _catImage.releaseContDrag = true;
        _catBackImage.releaseContDrag = true;
        _bable = _animation.catArmature.getBone('bable');
        changeCatTexture(_id);
        _source.addChild(_catImage);
        _source.addChild(_catBackImage);
        _animation.catImage = _catImage;
        _animation.catBackImage = _catBackImage;
        showFront(true);
        addShadow();
        _bable.visible =  false;
        _timer = int(4 + Math.random() * 20);
        g.gameDispatcher.addToTimer(catTopBable);
    }

    public function get idMan():int { return _id; }
    override public function get source():TownAreaBuildSprite { return _source; }
    public function set workRandom(v:Boolean):void { _isRandomWork = v; }
    public function get isWorkRandom():Boolean { return _isRandomWork; }

    private function onClick():void {
        for (var i:int = 0; i < g.managerQuest.userQuests.length; i++) {
            if (g.managerQuest.userQuests[i].questCatId == _id) {
                g.managerQuest.showWOForQuest(g.managerQuest.userQuests[i]);
                break;
            }
        }
    }

    override public function flipIt(v:Boolean):void {
        _animation.flipIt(v);
        _isFlip = v;
    }

    public function get isFlip():Boolean { return _isFlip; }
    public function get isFree():Boolean { return _isFree; }
    public function get decorAnimation():DecorAnimation { return _decorAnimation; }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChildAt(im, 0);
    }

    override public function showFront(v:Boolean):void {
        _animation.showFront(v);
//        if (heroEyes) {
//            if (v) heroEyes.startAnimations();
//            else heroEyes.stopAnimations();
//        }
    }

    override public function set visible(value:Boolean):void {
        if (!value)  _animation.stopIt();
        super.visible = value;
    }

    public function pauseIt(v:Boolean):void {
        if (v) {
            if (_currentPath && _currentPath.length) {
                setPosition(_currentPath.pop());
                updatePosition();
            }
            killAllAnimations();
            _callbackOnWalking = null;
        } else {
            if (_isFree) makeFreeCatIdle();
        }
    }

    public function set isFree(value:Boolean):void {
        _isFree = value;
        if (_isFree) makeFreeCatIdle();
        else killAllAnimations();
    }

    override public function walkAnimation():void {
        _animation.playIt('walk');
        super.walkAnimation();
    }
    override public function walkIdleAnimation():void {
        _animation.playIt('walk');
        super.walkIdleAnimation();
    }
    override public function runAnimation():void {
        _animation.playIt('run');
        super.runAnimation();
    }
    override public function stopAnimation():void {
        _animation.stopIt();
        super.stopAnimation();
    }
    override public function idleAnimation():void {
            showFront(true);
            var r:int = int(Math.random()*18);
            if (r > 11) {
                _animation.playIt('breath', true, makeFreeCatIdle);
            } else {
                switch (r) {
                    case 0: _animation.playIt('idle1', true, makeFreeCatIdle); break;
                    case 1: _animation.playIt('idle2', true, makeFreeCatIdle); break;
                    case 2: _animation.playIt('idle3', true, makeFreeCatIdle); break;
                    case 3: _animation.playIt('idle4', true, makeFreeCatIdle); break;
                    case 4: _animation.playIt('idle5', true, makeFreeCatIdle); break;
                    case 5: _animation.playIt('idle6', true, makeFreeCatIdle); break;
                    case 6: _animation.playIt('idle7', true, makeFreeCatIdle); break;
                    case 7: _animation.playIt('idle8', true, makeFreeCatIdle); break;
                    case 8: _animation.playIt('idle9', true, makeFreeCatIdle); break;
                    case 9: _animation.playIt('idle9', true, makeFreeCatIdle); break;
                    case 11: _animation.playIt('breath', true, makeFreeCatIdle); break;
                    case 10:
                        switch (_id) {
                            case 8: _animation.playIt('akril', true, makeFreeCatIdle); break;
                            case 9: _animation.playIt('agur', true, makeFreeCatIdle); break;
                            case 13: _animation.playIt('bulavka', true, makeFreeCatIdle); break;
                            case 14: _animation.playIt('businka', true, makeFreeCatIdle); break;
                            case 10: _animation.playIt('igolochka', true, makeFreeCatIdle); break;
                            case 6: _animation.playIt('iris', true, makeFreeCatIdle); break;
                            case 5: _animation.playIt('kruchek', true, makeFreeCatIdle); break;
                            case 11: _animation.playIt('lentochka', true, makeFreeCatIdle); break;
                            case 7: _animation.playIt('naperdstok', true, makeFreeCatIdle); break;
                            case 15: _animation.playIt('petelka', true, makeFreeCatIdle); break;
                            case 12: _animation.playIt('pryaga', true, makeFreeCatIdle); break;
                            case 16: _animation.playIt('sintetika', true, makeFreeCatIdle); break;
                            case 4: _animation.playIt('stegok', true, makeFreeCatIdle); break;
                            case 3: _animation.playIt('uzelok', true, makeFreeCatIdle); break;
                        }
                        break;
                }
            }
        super.idleAnimation();
    }

    override public function sleepAnimation():void {
        showFront(true);
        super.sleepAnimation();
    }
    private function changeCatTexture(id:int):void {
        var st:String;
        var lid:String;
        var st2:String;
        switch (_dataCats.color) {
            case OrderCat.BLACK_MAN:
                st = 'black_c_m';
                st2 = '_black';
                lid = 'black';
                break;
            case OrderCat.BLACK_WOMAN:
                st = 'black_c_w';
                st2 = '_black';
                lid = 'black';
                break;
            case OrderCat.BLUE_MAN:
                st = 'blue_c_m';
                st2 = '_blue';
                lid = 'blue';
                break;
            case OrderCat.BLUE_WOMAN:
                st = 'blue_c_w';
                st2 = '_blue';
                lid = 'blue';
                break;
            case OrderCat.GREEN_MAN:
                st = 'green_c_m';
                st2 = '_green';
                lid = 'green';
                break;
            case OrderCat.GREEN_WOMAN:
                st = 'green_c_w';
                st2 = '_green';
                lid = 'green';
                break;
            case OrderCat.BROWN_MAN:
                st = 'brown_c_m';
                st2 = '_brown';
                lid = 'brown';
                break;
            case OrderCat.BROWN_WOMAN:
                st = 'brown_c_w';
                st2 = '_brown';
                lid = 'brown';
                break;
            case OrderCat.ORANGE_MAN:
                st = 'orange_c_m';
                st2 = '_orange';
                lid = 'orange';
                break;
            case OrderCat.ORANGE_WOMAN:
                st = 'orange_c_w';
                st2 = '_orange';
                lid = 'orange';
                break;
            case OrderCat.PINK_MAN:
                st = 'pink_c_m';
                st2 = '_pink';
                lid = 'pink';
                break;
            case OrderCat.PINK_WOMAN:
                st = 'pink_c_w';
                st2 = '_pink';
                lid = 'pink';
                break;
            case OrderCat.WHITE_MAN:
                st = 'white_c_m';
                st2 = '_white';
                lid = 'white';
                break;
            case OrderCat.WHITE_WOMAN:
                st = 'white_c_w';
                st2 = '_white';
                lid = 'white';
                break;
        }
        var vii1:Slot = _animation.catArmature.getSlot('vii1');
        var vii2:Slot = _animation.catArmature.getSlot('vii2');
        if (_dataCats.isWoman) {
            if (vii1 && vii1.display) vii1.display.visible = true;
            if (vii2 && vii2.display) vii2.display.visible = true;
        } else {
            if (vii1 && vii1.display) {
                vii1.display.visible = false;
                _animation.catArmature.removeSlot(vii1);
            }
            if (vii2 && vii2.display) {
                vii2.display.visible = false;
                _animation.catArmature.removeSlot(vii2);
            }
        }
        releaseFrontTexture(st, lid);
        releaseBackTexture(st);
    }

    private function releaseFrontTexture(st:String, lid:String):void {
        changeTexture("head", st + "_head_front", _animation.catArmature);
        changeTexture("body", st + "_body_front", _animation.catArmature);
        changeTexture("handLeft", st + '_l_hand_front', _animation.catArmature);
        changeTexture("handLeft 2copy", st + '_l_hand_front', _animation.catArmature);
        changeTexture("legLeft", st + '_l_leg_front', _animation.catArmature);
        changeTexture("handRight", st + '_r_hand_front', _animation.catArmature);
        changeTexture("legRight", st + '_r_leg_front', _animation.catArmature);
        changeTexture("tail", st + '_tail_front', _animation.catArmature);
        changeTexture("lid_l", 'lid_l_' + lid, _animation.catArmature);
        changeTexture("lid_r", 'lid_r_' + lid, _animation.catArmature);
    }

    private function releaseBackTexture(st:String):void {
        changeTexture("head", st + "_head_back", _animation.catBackArmature);
        changeTexture("body", st + "_body_back", _animation.catBackArmature);
        changeTexture("handLeft", st + '_l_hand_back', _animation.catBackArmature);
        changeTexture("legLeft", st + '_l_leg_back', _animation.catBackArmature);
        changeTexture("handRight", st + '_r_hand_back', _animation.catBackArmature);
        changeTexture("legRight", st + '_r_leg_back', _animation.catBackArmature);
        changeTexture("tail", st + '_tail_front', _animation.catBackArmature);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
        var b:Slot = arma.getSlot(oldName);
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        b.displayList = null;
        b.display = im;
    }

// play Direct label
    public function playDirectLabel(label:String, playOnce:Boolean, callback:Function):void {
        showFront(true);
//        if (heroEyes) heroEyes.startAnimations();
        _animation.playIt(label, playOnce, callback);
    }

// SIMPLE IDLE
    private var timer:int;
    public function makeFreeCatIdle(showCatEmotion:Boolean = false):void {
        freeIdleGo = !freeIdleGo;
//        if ((g.tuts.isTuts && _type == MAN) || (g.miniScenes.isMiniScene && _type == MAN)) {
//            idleAnimation();
////            timer = 5 + int(Math.random() * 10);
////            g.gameDispatcher.addToTimer(renderForIdleFreeCat);
////            renderForIdleFreeCat();
//            return;
//        }
        var r:Number = Math.random();
        if (freeIdleGo && !showCatEmotion && r > .9) {
            g.managerCats.goIdleCatToPoint(this, g.townArea.getRandomFreeCell(posX,posY), makeFreeCatIdle);
        }
        else {
            idleAnimation();
        }
    }

    public function get isIdleGoNow():Boolean { return !freeIdleGo; }

    private function renderForIdleFreeCat():void {
        timer--;
        if (timer <= 0) {
            stopAnimation();
            g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
            makeFreeCatIdle();
        }
    }

    public function killAllAnimations():void {
        stopAnimation();
        _currentPath = [];
        TweenMax.killTweensOf(_source);
        timer = 0;
        g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
    }

    public function showBubble(st:String, delay:Number=0):void {
        var type:int;
        if (st.length > 140) {
            type = TutorialTextBubble.BIG;
        } else if (st.length > 60) {
            type = TutorialTextBubble.MIDDLE;
        } else {
            type = TutorialTextBubble.SMALL;
        }
        try {
            if (_bubble) {
                _bubble.showBubble(st, _isFlip, type);
                bShowBubble = true;
                if (_isFlip) {
                    _bubble.setXY(20 + _source.x, -50 + _source.y);
                } else {
                    _bubble.setXY(-20 + _source.x, -50 + _source.y);
                }
            }
        } catch (e:Error) {
            bShowBubble = false;
            Cc.error('TutorialCat showBubble error: ' + e.message + '  step: ' + g.user.tutorialStep);
        }
    }

    public function hideBubble():void {
        if (_bubble) {
            bShowBubble = false;
            _bubble.clearIt();
        }
    }

    private function catTopBable():void {
        _timer--;
        if (_timer <= 0) {
            g.gameDispatcher.removeFromTimer(catTopBable);
            _bable.visible =  !_bable.visible;
            _timer = int(4 + Math.random() * 9);
            g.gameDispatcher.addToTimer(catTopBable);
        }
    }

// DELETE
    override public function deleteIt():void {
        killAllAnimations();
        removeFromMap();
        _animation.deleteWorker();
        _catImage.removeChild(_animation.catArmature.display as Sprite);
        _catBackImage.removeChild(_animation.catBackArmature.display as Sprite);
        _animation.deleteArmature(_animation.catArmature);
        _animation.deleteArmature(_animation.catBackArmature);
        _animation.clearIt();
        super.deleteIt();
        _catImage = null;
        _catBackImage = null;
    }
}
}
