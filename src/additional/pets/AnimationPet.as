/**
 * Created by andy on 1/27/18.
 */
package additional.pets {
import com.junkbyte.console.Cc;
import data.StructureDataPet;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class AnimationPet {
    private var g:Vars = Vars.getInstance();
    private var _pet:PetMain;
    private var _petData:StructureDataPet;
    private var _parent:Sprite;
    private var _armature:Armature;
    private var _armatureBack:Armature;
    private var _petImage:Sprite;
    private var _petBackImage:Sprite;
    private var _defaultScaleX:int = 1;
    private var _defaultBackScaleX:int = 1;
    private var _isBack:Boolean;
    private var _isWalking:Boolean;  // pet can Walk or Run for front and Run for back
    private var _currentLabel:String;
    private var _animationCallback:Function;
    
    public function AnimationPet(s:Sprite, p:PetMain) {
        _parent = s;
        _pet = p;
        _currentLabel = '';
        _isBack = false;
        _petImage = new Sprite();
        _petBackImage = new Sprite();
        _parent.addChild(_petImage);
        _parent.addChild(_petBackImage);
        _petBackImage.visible = false;
    }
    
    public function fillArmatures(petData:StructureDataPet):void {
        _petData = petData;
        _armature = g.allData.factory[_petData.url].buildArmature(_petData.image);
        _armatureBack = g.allData.factory[_petData.url].buildArmature(_petData.image + "_back");
        _petImage.addChild(_armature.display as StarlingArmatureDisplay);
        _petBackImage.addChild(_armatureBack.display as StarlingArmatureDisplay);
        if (!WorldClock.clock.contains(_armature)) WorldClock.clock.add(_armature);
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, loopEnd);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, loopEnd);
        if (g.allData.atlas['customisationPetsAtlas']) _pet.releaseTexture();
            else g.load.loadAtlas('x1/customisationPetsAtlas', 'customisationPetsAtlas', _pet.releaseTexture);
    }

    public function changeTexture(oldName:String, newName:String, isFront:Boolean):void {
        var im:Image = new Image(g.allData.atlas['customisationPetsAtlas'].getTexture(newName));
        var b:Slot;
        if (isFront) b = _armature.getSlot(oldName);
            else b = _armatureBack.getSlot(oldName);
        if (b && im) {
            b.displayList = null;
            b.display = im;
            if (im.width == 100 && im.height == 100) {
                Cc.ch('pet', 'probably no im: ' + newName + '  for petId: ' + _petData.id);
            }
        } else {
            if (!b) Cc.ch('pet', 'no slot: ' + oldName + '  for petId: ' + _petData.id);
        }
    }
    
    public function get armature():Armature { return _armature; }
    public function get armatureBack():Armature { return _armatureBack; }
    public function set defaultScaleX(v:int):void { _defaultScaleX = v;}
    public function set defaultBackScaleX(v:int):void { _defaultBackScaleX = v;}
    public function get isBack():Boolean { return _isBack; }
    public function get isWalking():Boolean { return _isWalking; }
    public function set isWalking(v:Boolean):void { _isWalking = v; }

    public function flipIt(v:Boolean):void {
        if (v) {
            _petImage.scaleX = -1 * _defaultScaleX;
            _petBackImage.scaleX = _defaultBackScaleX;
        } else {
            _petImage.scaleX = _defaultScaleX;
            _petBackImage.scaleX = -1 * _defaultBackScaleX;
        }
    }

    public function showFront(v:Boolean):void {
        if (v) {
            _isBack = false;
            _petImage.visible = true;
            if (!WorldClock.clock.contains(_armature)) WorldClock.clock.add(_armature);
            _petBackImage.visible = false;
            if (WorldClock.clock.contains(_armatureBack)) WorldClock.clock.remove(_armatureBack);
        } else {
            _isBack = true;
            _petBackImage.visible = true;
            if (!WorldClock.clock.contains(_armatureBack)) WorldClock.clock.add(_armatureBack);
            _petImage.visible = false;
            if (WorldClock.clock.contains(_armature)) WorldClock.clock.remove(_armature);
        }
    }

    public function deleteIt():void {
        if (!_armature) return;
        WorldClock.clock.remove(_armature);
        _armature.removeEventListener(EventObject.COMPLETE, loopEnd);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, loopEnd);
        if (_petImage && _armature) _petImage.removeChild(_armature.display as StarlingArmatureDisplay);
        if (_petBackImage  && _armatureBack) _petBackImage.removeChild(_armatureBack.display as StarlingArmatureDisplay);
        if (_armature && WorldClock.clock.contains(_armature)) WorldClock.clock.remove(_armature);
        if (_armatureBack && WorldClock.clock.contains(_armatureBack)) WorldClock.clock.remove(_armatureBack);
        if (_petImage) _petImage.dispose();
        if (_petBackImage) _petBackImage.dispose();
        if (_armature) _armature = null;
        if (_armatureBack) _armatureBack = null;
        WorldClock.clock.remove(_armature);
    }

    /// idle01 - front: run, idle02, sleep, eat; idle01 - back: run
    public function walkAnimation():void {
        if (!_armature) return;
        _animationCallback = null;
        if (!_isBack) {
            _currentLabel = 'walk';
            _armature.animation.gotoAndPlayByFrame('walk');
        } else {
            _currentLabel = 'idle01';
            _armatureBack.animation.gotoAndPlayByFrame('idle01');
        }
    }

    public function runAnimation():void {
        if (!_armature) return;
        _animationCallback = null;
        if (!_isBack) {
            _currentLabel = 'run';
            _armature.animation.gotoAndPlayByFrame('run');
        } else {
            _currentLabel = 'idle01';
            _armatureBack.animation.gotoAndPlayByFrame('idle01');
        }
    }

    public function sleepAnimation():void {
        if (!_armature) return;
        _animationCallback = null;
        _currentLabel = 'sleep';
        _armature.animation.gotoAndPlayByFrame('sleep');
    }

    public function playAnimation(callback:Function):void {  // callback == null  ===  loop == 1000000000
        if (!_armature) return;
        _animationCallback = callback;
        var n:int = int(Math.random()*2);
        if (_pet is RabbitPet) n = int(Math.random()*3);
        switch (n) {
            case 0: _currentLabel = 'run2'; break;
            case 1: _currentLabel = 'idle'; break;
            case 2: _currentLabel = 'run3'; break;
        }
        _armature.animation.gotoAndPlayByFrame(_currentLabel);
    }

    public function eatAnimation(f:Function):void {
        if (!_armature) return;
        _animationCallback = f;
        _armature.animation.gotoAndPlayByFrame('eat');  // --> smth wrong with animation
//        Utils.createDelay(4, fEnd);  // temp fix
    }

    private function loopEnd(e:Event=null):void {
        if (_animationCallback != null) {
            _animationCallback.apply(null, [_pet]);
        } else {
            if (_currentLabel == '') return;
            if (_currentLabel == 'idle01') _armatureBack.animation.gotoAndPlayByFrame(_currentLabel);
                else _armature.animation.gotoAndPlayByFrame(_currentLabel);
        }
    }

    public function stopAnimation():void {
        if (!_armature) return;
        _animationCallback = null;
        _currentLabel = '';
        _armature.animation.gotoAndStopByFrame('run');
        _armatureBack.animation.gotoAndStopByFrame('idle01');
    }
}
}
