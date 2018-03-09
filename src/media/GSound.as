/**
 * Created by andriy.grynkiv on 9/16/14.
 */
package media {
import com.greensock.TweenMax;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

import utils.Utils;

public class GSound {
    private var _sound:Sound;
    private var _soundChanell:SoundChannel;
    private var _soundChanellBird:SoundChannel;
    private var _isPlaying:Boolean = true;

    public function GSound(snd:Sound = null):void {
        _soundChanell = new SoundChannel();
        _soundChanellBird = new SoundChannel();
        snd ? _sound = snd : _sound = new Sound();
        _sound.addEventListener(IOErrorEvent.IO_ERROR, ioError);
    }

    public function load(stream:URLRequest):void {
        _sound.load(stream);
    }

    public function play(count:int = 0, useVolume:Boolean = false, callback:Function = null, idPlay:int = 0, volume:int = 1):void {
        var sd:SoundTransform;

        if (useVolume) {
            sd = new SoundTransform(0);
        } else {
            sd = null;
        }

        if (useVolume) {
            var f3:Function = function ():void {
                if (callback != null) {
                    callback.apply();
                }
            };
            var f2:Function = function ():void {
                _soundChanell.removeEventListener(Event.SOUND_COMPLETE,f2);
                if (idPlay == SoundConst.MAIN_MUSIC) f3();
                else Utils.createDelay(int(2 + Math.random()* 3),f3)

            };
            _soundChanell = _sound.play(0, count, sd);
            _soundChanell.addEventListener(Event.SOUND_COMPLETE, f2);
//            _sound.
            if (!_soundChanell) return;
            TweenMax.to(_soundChanell, 0, {volume:volume});
        } else {
            _soundChanell = _sound.play(0, count);
        }
    }

    public function playBirdAnimals(count:int = 0, callback:Function = null):void {
//        var sd:SoundTransform;
//
//        if (useVolume) {
//            sd = new SoundTransform(0);
//        } else {
//            sd = null;
//        }
//        var f3:Function = function ():void {
//            trace('cvirk cvrik');
//            if (callback != null) {
//                callback.apply();
//            }
//        };
//        var f2:Function = function ():void {
//            trace('kyrluk kyrluk');
//            _soundChanellBird.removeEventListener(Event.SOUND_COMPLETE,f2);
//            Utils.createDelay(int(4 * Math.random()),f3)
//
//        };
//        _soundChanellBird.addEventListener(Event.SOUND_COMPLETE, f2);
        _soundChanellBird = _sound.play(0, count);

    }

    public function stop():void {
        if (!_soundChanell) return;

        TweenMax.killTweensOf(_soundChanell);
        _soundChanell.stop();
    }

    public function get isPlaying():Boolean {
        return _isPlaying;
    }

    private function ioError(e:IOErrorEvent):void {
        _isPlaying = false;
    }
}
}