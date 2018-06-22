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

import starling.display.Image;
import starling.display.Sprite;

import tutorial.TutorialTextBubble;

import utils.CSprite;
import utils.Utils;

public class HeroCat extends BasicCat{
    private var _catImage:CSprite;
    private var _catWateringAndFeed:Sprite;
    private var _catBackImage:CSprite;
    private var _isFree:Boolean;
    private var _type:int;
    private var heroEyes:HeroEyesAnimation;
    private var _decorAnimation:DecorAnimation;
    private var freeIdleGo:Boolean;
    public var isLeftForFeedAndWatering:Boolean; // choose the side of ridge for watering
//    public var curActiveRidge:Ridge; //  for watering ridge
//    public var curActiveFarm:Farm;  // for feed animal at farm
    private var _animation:HeroCatsAnimation;
    private var _isRandomWork:Boolean;
    public var activeRandomWorkBuild:WorldObject;
    private var _bubble:TutorialTextBubble;
    private var _isFlip:Boolean;
    public var bShowBubble:Boolean;
    private var _countAnimation:int;
    private var _bable:Bone;
    private var _timer:int;

    public function HeroCat(type:int) {
        super();
        _isRandomWork = false;
        _type = type;
        _isFree = true;
        _source = new TownAreaBuildSprite();
//        _source.touchable = false;
        _catImage = new CSprite();
        _catImage.releaseContDrag = true;
        _catImage.endClickCallback = onClick;
        _catWateringAndFeed = new Sprite();
        _catBackImage = new CSprite();
        _catBackImage.releaseContDrag = true;
        _catBackImage.endClickCallback = onClick;
        freeIdleGo = true;
        bShowBubble = false;
        _animation = new HeroCatsAnimation();
        _animation.catArmature = g.allData.factory['cat_main'].buildArmature("cat");
        _animation.catBackArmature = g.allData.factory['cat_main'].buildArmature("cat_back");
        _catImage.addChild(_animation.catArmature.display as StarlingArmatureDisplay);
        _catBackImage.addChild(_animation.catBackArmature.display as StarlingArmatureDisplay);
        _bable = _animation.catArmature.getBone('bable');
        if (_type == WOMAN) {
            releaseFrontWoman(_animation.catArmature);
            releaseBackWoman(_animation.catBackArmature);
        } else {
            releaseFrontMan(_animation.catArmature);
            releaseBackMan(_animation.catBackArmature);
        }
        var st2:String = 'grey_c_m_worker_head_front';
        var st3:String = '';
        if (_type == WOMAN) {
            st2 = 'orange_c_w_worker_head_front';
            st3 = '_w';
        }
//        heroEyes = new HeroEyesAnimation(g.allData.factory['cat_main'], _animation.catArmature, st2, st3, _type == WOMAN);
        _source.addChild(_catImage);
        _source.addChild(_catWateringAndFeed);
        _source.addChild(_catBackImage);
        _animation.catImage = _catImage;
        _animation.catBackImage = _catBackImage;
        _animation.catWorkerImage = _catWateringAndFeed;
        _bable.visible = false;
        showFront(true);
        _bubble = new TutorialTextBubble(g.cont.animationsCont);
        addShadow();
        _timer = int(4 + Math.random() * 20);
        g.gameDispatcher.addToTimer(catTopBable);
    }

    private function onClick():void {
        for (var i:int = 0; i < g.managerQuest.userQuests.length; i++) {
            if (_type == WOMAN && g.managerQuest.userQuests[i].questCatId == 2) {
                g.managerQuest.showWOForQuest(g.managerQuest.userQuests[i]);
                break;
            } else if (_type == MAN && g.managerQuest.userQuests[i].questCatId == 1) {
                g.managerQuest.showWOForQuest(g.managerQuest.userQuests[i]);
                break;
            }
        }
    }

    public function get typeMan():int { return _type; }
    public function set workRandom(v:Boolean):void { _isRandomWork = v; }
    public function get isWorkRandom():Boolean { return _isRandomWork; }
    override public function flipIt(v:Boolean):void {
        _animation.flipIt(v);
        _isFlip = v;
    }
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

    public function set decorAnimation(decorAnimation:DecorAnimation):void {
        _decorAnimation = decorAnimation;
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
        if (Math.random() > .2 || (g.tuts.isTuts && _type == MAN) || (g.miniScenes.isMiniScene && _type == MAN)) {
            showFront(true);
            var r:int = int(Math.random()*12);
            if (r > 8) {
                _animation.playIt('idle', true, makeFreeCatIdle);
            } else {
                switch (r) {
                    case 0:
                        _animation.playIt('smile', true, makeFreeCatIdle);
                        break;
                    case 1:
                        _animation.playIt('happy', true, makeFreeCatIdle);
                        break;
                    case 2:
                        _animation.playIt('look', true, makeFreeCatIdle);
                        break;
                    case 3:
                        _animation.playIt('surprise', true, makeFreeCatIdle);
                        break;
                    case 4:
                        _animation.playIt('hi', true, makeFreeCatIdle);
                        break;
                    case 5:
                        _animation.playIt('hello', true, makeFreeCatIdle);
                        break;
                    case 6:
                        _animation.playIt('work', true, makeFreeCatIdle);
                        break;
                    case 7:
                        _animation.playIt('laugh', true, makeFreeCatIdle);
                        break;
                    case 8:
                        _animation.playIt('jump', true, makeFreeCatIdle);
                        break;
                }
            }
        } else {
            showFront(false);
            _animation.playIt('idle', true, makeFreeCatIdle);
        }
        super.idleAnimation();
    }

    override public function sleepAnimation():void {
        showFront(true);
        super.sleepAnimation();
    }

    private function releaseFrontMan(arma:Armature):void {
        changeTexture("head", "grey_c_m_worker_head_front", arma);
        changeTexture("body", "grey_c_m_worker_body_front", arma);
        changeTexture("handLeft", "grey_c_m_worker_l_hand_front", arma);
        changeTexture("legLeft", "grey_c_m_worker_l_leg_front", arma);
        changeTexture("handRight", "grey_c_m_worker_r_hand_front", arma);
        changeTexture("legRight", "grey_c_m_worker_r_leg_front", arma);
        changeTexture("tail", "grey_c_m_worker_tail_front", arma);
        changeTexture("handRight copy", "grey_c_m_worker_r_hand_front", arma);
        changeTexture("lid_r", "lid_r", arma);
        changeTexture("lid_l", "lid_l", arma);
        var vii1:Slot = arma.getSlot('vii1');
        var vii2:Slot = arma.getSlot('vii2');
        if (vii1 && vii1.display) {
            vii1.display.visible = false;
            arma.removeSlot(vii1);
        }
        if (vii2 && vii2.display) {
            vii2.display.visible = false;
            arma.removeSlot(vii2);
        }
    }

    private function releaseBackMan(arma:Armature):void {
        changeTexture("head", "grey_c_m_worker_head_back", arma);
        changeTexture("body", "grey_c_m_worker_body_back", arma);
        changeTexture("legLeft", "grey_c_m_worker_l_leg_back", arma);
        changeTexture("handLeft", "grey_c_m_worker_l_hand_back", arma);
        changeTexture("handRight", "grey_c_m_worker_r_hand_back", arma);
        changeTexture("legRight", "grey_c_m_worker_r_leg_back", arma);
        changeTexture("tail11", "grey_c_m_worker_tail_front", arma);
    }

    private function releaseFrontWoman(arma:Armature):void {
        changeTexture("head", "orange_c_w_worker_head_front", arma);
        changeTexture("body", "orange_c_w_worker_body_front", arma);
        changeTexture("handLeft", "orange_c_w_worker_l_hand_front", arma);
        changeTexture("legLeft", "orange_c_w_worker_l_leg_front", arma);
        changeTexture("handRight", "orange_c_w_worker_r_hand_front", arma);
        changeTexture("legRight", "orange_c_w_worker_r_leg_front", arma);
        changeTexture("tail", "orange_c_w_worker_tail_front", arma);
        changeTexture("handRight copy", "orange_c_w_worker_r_hand_front", arma);
        changeTexture("lid_r", "lid_r_w", arma);
        changeTexture("lid_l", "lid_l_w", arma);
    }

    private function releaseBackWoman(arma:Armature):void {
        changeTexture("head", "orange_c_w_worker_head_back", arma);
        changeTexture("body", "orange_c_w_worker_body_back", arma);
        changeTexture("handLeft", "orange_c_w_worker_l_hand_back", arma);
        changeTexture("legLeft", "orange_c_w_worker_l_leg_back", arma);
        changeTexture("handRight", "orange_c_w_worker_r_hand_back", arma);
        changeTexture("legRight", "orange_c_w_worker_r_leg_back", arma);
        changeTexture("tail11", "orange_c_w_worker_tail_front", arma);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
//        var im:Image = g.allData.factory['cat_main'].getTextureDisplay('clothTextureTemp', newName) as Image;
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        var b:Slot = arma.getSlot(oldName);
        if (b && im) {
            b.displayList = null;
            b.display = im;
        }
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
        if ((g.tuts.isTuts && _type == MAN) || (g.miniScenes.isMiniScene && _type == MAN)) {
            idleAnimation();
//            timer = 5 + int(Math.random() * 10);
//            g.gameDispatcher.addToTimer(renderForIdleFreeCat);
//            renderForIdleFreeCat();
            return;
        }
        if (freeIdleGo && Math.random() > .4 && !showCatEmotion) {
            g.managerCats.goIdleCatToPoint(this, g.townArea.getRandomFreeCell(posX,posY), makeFreeCatIdle);
        } else {
            var b:Boolean = false;
            var r:Number = Math.random();

            if (r <= .02) {
                if (g.townArea.getCityObjectsByType(BuildType.DECOR_ANIMATION)) {
                    var arr:Array = g.townArea.getCityObjectsByType((BuildType.DECOR_ANIMATION));
                    if (arr.length > 0) {
                        for (var i:int = 0; i < arr.length; i++) {
                            if ((arr[i] as DecorAnimation).catNeed && !(arr[i] as DecorAnimation).decorWork && !(arr[i] as DecorAnimation).catRun && ((arr[i] as DecorAnimation).needCatsCount() <= 1)) {
                                (arr[i] as DecorAnimation).forceStartDecorAnimation(this);
                                b = true;
                                break;
                            }
                        }
                    }
                }
            }
            if (!b) {
//                trace(_type + ' SEX + MAMAMAMAMAM');
                idleAnimation();
//                timer = 5 + int(Math.random() * 10);
//                g.gameDispatcher.addToTimer(renderForIdleFreeCat);
//                renderForIdleFreeCat();
            }
        }
    }
    
    public function get isIdleGoNow():Boolean { return !freeIdleGo; }

    private function renderForIdleFreeCat():void {
        timer--;
        if (timer <= 0) {
            stopAnimation();
//            g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
            makeFreeCatIdle();
        }
    }

    public function killAllAnimations():void {
        stopAnimation();
        _currentPath = [];
        TweenMax.killTweensOf(_source);
//        timer = 0;
//        g.gameDispatcher.removeFromTimer(renderForIdleFreeCat);
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

// WORK WITH PLANT
    public function onArrivedCatToRidge():void {
        var p:Point = new Point();
        isLeftForFeedAndWatering = Math.random() > .5;
        if (isLeftForFeedAndWatering) {
            p.x = activeRandomWorkBuild.posX;
            p.y = activeRandomWorkBuild.posY + 1;
        } else {
            p.x = activeRandomWorkBuild.posX + 1;
            p.y = activeRandomWorkBuild.posY;
        }
        g.managerCats.goCatToPoint(this, p, onArrivedCatToRidgePoint);
    }

    private function onArrivedCatToRidgePoint():void {
        var onFinishWork:Function = function():void {
            _isRandomWork = false;
            if (_type == MAN) {
                g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkMan);
                (activeRandomWorkBuild as Ridge).catOnAnimation = false;
            }
            else {
                g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkWoman);
                (activeRandomWorkBuild as Ridge).catOnAnimation = false;
            }
            removeWorker();
        };
        if ((activeRandomWorkBuild as Ridge).plant)
            workWithPlant(onFinishWork);
        else onFinishWork();
    }

    public function  workWithPlant(callback:Function):void {
        _animation.deleteWorker();
        _animation.catWorkerArmature = g.allData.factory['cat_watering_can'].buildArmature("cat");
        var viyi:Slot = _animation.catWorkerArmature.getSlot('viyi');
        if (_type == WOMAN) {
            releaseFrontWoman(_animation.catWorkerArmature);
            if (viyi && viyi.display) viyi.display.visible = true;
        } else {
            releaseFrontMan(_animation.catWorkerArmature);
            if (viyi && viyi.display) viyi.display.visible = false;
        }
        flipIt(isLeftForFeedAndWatering);
        _animation.playIt('open', true, makeWatering, callback);
        _countAnimation = 2 + Math.random()* 3;
    }

    private function makeWatering(callback:Function):void {
        _animation.playIt('work', true, makeWateringIdle, callback);
    }

    private function makeWateringIdle(callback:Function):void {
        _countAnimation --;
        if (_countAnimation > 0) {
            makeWatering(callback);
        } else {
            var fClose:Function = function ():void {
                if (callback != null) {
                    callback.apply();
                }
            };
            _animation.playIt('close', true, fClose);
        }
    }

    public function removeWorker():void {
       _animation.deleteWorker();
        killAllAnimations();
        showFront(true);
        _catImage.visible = true;
        freeIdleGo = false;
        makeFreeCatIdle();
    }

// WORK WITH FARM
    public function onArrivedCatToFarm():void {
        var p:Point = new Point();
        var k:int = 3 + int(Math.random()*3);
        isLeftForFeedAndWatering = Math.random() > .5;
        if (isLeftForFeedAndWatering) {
            p.x = activeRandomWorkBuild.posX;
            p.y = activeRandomWorkBuild.posY + k;
        } else {
            p.x = activeRandomWorkBuild.posX + k;
            p.y = activeRandomWorkBuild.posY;
        }
        g.managerCats.goCatToPoint(this, p, onArrivedCatToFarmPoint);
    }

    private function onArrivedCatToFarmPoint():void {
        var onFinishWork:Function = function():void {
            _isRandomWork = false;
            if (_type == MAN) {
                g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkMan);
                (activeRandomWorkBuild as Farm).catOnAnimation = false;
            }
            else {
                g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkWoman);
                (activeRandomWorkBuild as Farm).catOnAnimation = false;
            }
            removeWorker();
        };
        if ((activeRandomWorkBuild as Farm).dataAnimal.id == 6) workWithPlant(onFinishWork);
        else workWithFarm(onFinishWork);
    }

    public function workWithFarm(callback:Function):void {
        _animation.deleteWorker();
        _animation.catWorkerArmature = g.allData.factory['cat_feed'].buildArmature("cat");
        var viyi:Slot = _animation.catWorkerArmature.getSlot('viyi');
        if (_type == WOMAN) {
            releaseFrontWoman(_animation.catWorkerArmature);
            if (viyi && viyi.displayList.length) viyi.displayList[0].visible = true;
        } else {
            if (viyi && viyi.displayList.length) viyi.displayList[0].visible = false;
        }
        flipIt(isLeftForFeedAndWatering);

        makeFeeding(callback);
        _countAnimation = 2 + Math.random()* 3;
    }

    private function makeFeeding(callback:Function):void {
        _animation.playIt('work', true, makeFeedingPart1, callback);
    }

    private function makeFeedingPart1(callback:Function):void {
        makeFeedingParticles();
        _animation.playIt('work1', true, makeFeedingPart2, callback);
    }

    private function makeFeedingPart2(callback:Function):void {
        makeFeedingParticles();
        _animation.playIt('work2', true, makeFeedingPart3, callback);
    }

    private function makeFeedingPart3(callback:Function):void {
        makeFeedingParticles();
        _animation.playIt('work3', true, onFinishFeeding, callback);
    }

    private function onFinishFeeding(callback:Function):void {
        _countAnimation--;
        if (_countAnimation <= 0) {
            if (callback != null) callback.call();
        } else makeFeeding(callback);
    }

    private function makeFeedingParticles():void {
        var p:Point = new Point();
        p.x = -11;
        p.y = -92;
        p = (_animation.catArmature.display as Sprite).localToGlobal(p);
        (activeRandomWorkBuild as Farm).showParticles(p, isLeftForFeedAndWatering);
    }
    
// WORK WITH FABRICA
    public function onArrivedCatToFabrica():void {
        var onFinishWork:Function = function():void {
            _isRandomWork = false;
            visible = true;
                if (_type == MAN) {
                    g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkMan);
                    (activeRandomWorkBuild as Fabrica).catOnAnimation = false;
                }
                else {
                    g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkWoman);
                    (activeRandomWorkBuild as Fabrica).catOnAnimation = false;
                }
                removeWorker();
        };
        visible = false;
        (activeRandomWorkBuild as Fabrica).onHeroAnimation(onFinishWork, this);
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
        _catWateringAndFeed = null;
        _catBackImage = null;
    }


// SHOW FAIL CAT
    public function showFailCat(callback:Function):void {
        killAllAnimations();
        _animation.deleteWorker();
        _animation.playIt('fail', true, callback);
    }

// SIMPLE IDLE
    public function showSimpleIdle():void {
       _animation.playIt('idle');
    }

// JUMP CAT
    public function jumpCat(hello:Boolean = false):void {
        var f2:Function = function ():void {
            makeFreeCatIdle();
        };
        var f1:Function = function ():void {
            if (!hello) showFront(true);
            if (!hello) killAllAnimations();
            _animation.playIt('happy',true,f2);
        };
        if (hello) f1();
        else Utils.createDelay(int(Math.random() * 2) + 2,f1);
    }

// HELLO CAT
    public function helloCat():void {
        var f2:Function = function ():void {
            jumpCat(true);
        };
        var f1:Function = function ():void {
            showFront(true);
            killAllAnimations();
            _animation.playIt('hi',true,f2);
        };
        Utils.createDelay(int(Math.random() * 2) + 2,f1);
    }

    private function catTopBable():void {
        _timer--;
        if (_timer <= 0) {
            for (var i:int = 0; i < g.managerQuest.userQuests.length; i++) {
                if (_type == WOMAN && g.managerQuest.userQuests[i].questCatId == 2) {
                    g.gameDispatcher.removeFromTimer(catTopBable);
                    _bable.visible =  !_bable.visible;
                    _timer = int(4 + Math.random() * 9);
                    g.gameDispatcher.addToTimer(catTopBable);
                    return;
                } else if (_type == MAN && g.managerQuest.userQuests[i].questCatId == 1) {
                    g.gameDispatcher.removeFromTimer(catTopBable);
                    _bable.visible =  !_bable.visible;
                    _timer = int(4 + Math.random() * 9);
                    g.gameDispatcher.addToTimer(catTopBable);
                    return;
                }
            }
            g.gameDispatcher.removeFromTimer(catTopBable);
            _bable.visible =  false;
            _timer = int(4 + Math.random() * 9);
            g.gameDispatcher.addToTimer(catTopBable);
        }
    }

}
}
