/**
 * Created by andriy.grynkiv on 9/16/14.
 */
package media {
import build.farm.Farm;

import com.junkbyte.console.Cc;

import data.BuildType;

import data.BuildType;

import flash.media.Sound;
import flash.system.ApplicationDomain;

import manager.Vars;

import utils.Utils;

public class SoundManager {
    private var musics:Object = {};
    private var sounds:Object = {};
    private var bird:Object = {};
    private var talk:Object = {};
    private var _isPlayingMusic:Boolean = true;
    private var _isPlayingSound:Boolean = true;
    private var g:Vars = Vars.getInstance();
    private var _idMainPlay:int;
    private var _bChicken:Boolean;
    private var _bBee:Boolean;
    private var _bCow:Boolean;
    private var _bPig:Boolean;
    private var _bSheep:Boolean;
    private var _bGoat:Boolean;
    private var _bTalk:Boolean;

    public function SoundManager() {}

    public function load():void {
        _bChicken = false;
        _bBee = false;
        _bCow = false;
        _bPig = false;
        _bSheep = false;
        _bGoat = false;
        _bTalk = false;
        var url:String = g.dataPath.getGraphicsPath() + 'sounds/sounds.swf';
        g.load.loadSWFModule(url, loaded);
        _idMainPlay = -1;
    }

    public function set setTalk(b:Boolean):void {
        _bTalk = b;
    }

    private function loaded(response:ApplicationDomain):void {
        var i:int;
        var sound:Sound;
        var cl:Class;
        try {
            if (response.hasDefinition("farm_music")) {
                cl = response.getDefinition("farm_music") as Class;
                sound = new cl();
                addMusic(SoundConst.MAIN_MUSIC, sound);
            }

            if (response.hasDefinition("farm_music_short")) {
                cl = response.getDefinition("farm_music_short") as Class;
                sound = new cl();
                addMusic(SoundConst.MAIN_MUSIC_SHORT, sound);
            }

            if (response.hasDefinition("w1")) {
                cl = response.getDefinition("w1") as Class;
                sound = new cl();
                addMusic(SoundConst.MAIN_MUSIC_WATER, sound);
            }

            if (response.hasDefinition("tree2")) {
                cl = response.getDefinition("tree2") as Class;
                sound = new cl();
                addMusic(SoundConst.MAIN_MUSIC_TREE, sound);
            }

            if (response.hasDefinition("tree4")) {
                cl = response.getDefinition("tree4") as Class;
                sound = new cl();
                addMusic(SoundConst.MAIN_MUSIC_TREE2, sound);
            }

            i = 0;
            while (response.hasDefinition("Sound" + String(++i))) {
                cl = response.getDefinition("Sound" + String(i)) as Class;
                sound = new cl();
                addSound(i, sound);
            }

            i = 0;
            while (response.hasDefinition("b" + String(++i))) {
                cl = response.getDefinition("b" + String(i)) as Class;
                sound = new cl();
                addBird(i, sound);
            }

            i = 0;
            while (response.hasDefinition("t" + String(++i))) {
                cl = response.getDefinition("t" + String(i)) as Class;
                sound = new cl();
                addTalk(i, sound);
            }
        } catch (e:Error) {
            Cc.error('soundManagerError after loaded: ' + e.message);
        }
    }

    public function checkAnimal():void {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i].arrAnimals.length > 0 && arr[i].dataAnimal.id == 1) _bChicken = true;
            else if (arr[i].arrAnimals.length > 0 && arr[i].dataAnimal.id == 2) _bCow = true;
            else if (arr[i].arrAnimals.length > 0 && arr[i].dataAnimal.id == 3) _bPig = true;
            else if (arr[i].arrAnimals.length > 0 && arr[i].dataAnimal.id == 6) _bBee = true;
            else if (arr[i].arrAnimals.length > 0 && arr[i].dataAnimal.id == 7) _bSheep = true;
            else if (arr[i].arrAnimals.length > 0 && arr[i].dataAnimal.id == 8) _bGoat = true;
        }
    }

    private function addMusic(id:int, snd:Sound):void {
        musics[id] = new GSound(snd);
    }

    private function addSound(id:int, snd:Sound):void {
        sounds[id] = new GSound(snd);
    }

    private function addBird(id:int, snd:Sound):void {
        bird[id] = new GSound(snd);
    }

    private function addTalk(id:int, snd:Sound):void {
        talk[id] = new GSound(snd);
    }

    public function enabledMusic(value:Boolean):void {
        _isPlayingMusic = value;
        if (!_isPlayingMusic) {
            stopAllMusics();
        }
    }

    public function enabledSound(value:Boolean):void {
        _isPlayingSound = value;
        if (!_isPlayingSound) {
            stopAllSounds();
        }
    }

    public function managerMusic():void {
        if (!_isPlayingMusic) return;
        if (g.tuts.isTuts && g.user.tutorialStep == 1) {
            _idMainPlay = SoundConst.MAIN_MUSIC;
            playMusic(_idMainPlay, 1, 1);
        } else {
            var random:Number;
            if (_idMainPlay == 1) _idMainPlay = SoundConst.MAIN_MUSIC_SHORT;
            else {
                random = Math.random();
                if (random <= .2) {
                    _idMainPlay = SoundConst.MAIN_MUSIC;
                } else if (random <= .5) {
                    _idMainPlay = SoundConst.MAIN_MUSIC_TREE;
                } else if (random <= .85) {
                    _idMainPlay = SoundConst.MAIN_MUSIC_TREE2;
                } else {
                    _idMainPlay = SoundConst.MAIN_MUSIC_WATER;
                }
            }
            playMusic(_idMainPlay, 1, 1);
            managerBirdAndAnimals();
        }
    }

    private function managerBirdAndAnimals():void {
        if (_idMainPlay == SoundConst.MAIN_MUSIC_SHORT || _idMainPlay == SoundConst.MAIN_MUSIC || !_isPlayingMusic) return;
        var r:int = int(1 + Math.random() * 20);
        if (r > 17) {
            if (_bChicken && Math.random() > .6) playSound(SoundConst.CHICKEN_CLICK,1);
            else if (_bCow && Math.random() > .6) playSound(SoundConst.COW_CLICK,1);
            else if (_bBee && Math.random() > .6) playSound(SoundConst.BEE_CLICK,1);
            else if (_bSheep && Math.random() > .6) playSound(SoundConst.SHEEP_CLICK,1);
            else if (_bPig && Math.random() > .6) playSound(SoundConst.PIG_CLICK,1);
            else if (_bGoat && Math.random() > .6) playSound(SoundConst.GOAT_CLICK,1);
            else playSound(SoundConst.CHICKEN_CLICK,1);
            Utils.createDelay(int(2 + Math.random() * 3), managerBirdAndAnimals);
        } else {
            playMusicBirdAnimals(r ,1);
            Utils.createDelay(int(5 + Math.random() * 5), managerBirdAndAnimals);
        }
    }

    private function playMusic(idPlay:int, count:int = int.MAX_VALUE, volume:int = 1):void {
        var sound:GSound;
        if (_isPlayingMusic) {
            sound = musics[idPlay];
            if (sound && sound.isPlaying) {
                sound.play(count, true, managerMusic, idPlay, volume);
            }
        }
    }

    private function playMusicBirdAnimals(idPlay:int, count:int = int.MAX_VALUE):void {
        var sound:GSound;
        if (_isPlayingMusic) {
            sound = bird[idPlay];
            if (sound && sound.isPlaying) {
                sound.playBirdAnimals(count, managerBirdAndAnimals);
            }
        }
    }

    public function playSound(id:int, count:int = 1):void {
        var sound:GSound;
        if (_isPlayingSound) {
            sound = sounds[id];
            if (sound && sound.isPlaying) {
                sound.play(count);
            }
        }
    }

    public function playTalk():void {
        var random:int = 1 + Math.random() * 11;
        var sound:GSound;
        if (_isPlayingSound) {
            sound = talk[random];
            if (sound && sound.isPlaying) {
                sound.play(1);
            }
        }
        if (_bTalk) Utils.createDelay(2, playTalk);
    }

    public function stopSound(id:int):void {
        var sound:GSound;
        if (_isPlayingSound) {
            sound = sounds[id];

            if (sound && sound.isPlaying) {
                sound.stop();
            }
        }
    }

    public function stopAllMusics():void {
        var sound:GSound;
        for (var key:String in musics) {
            sound = musics[key];
            sound.stop();
        }
    }

    public function stopAllSounds():void {
        var sound:GSound;
        var key:String;
        for (key in sounds) {
            sound = sounds[key];
            sound.stop();
        }
    }

    public function get isPlayingMusic():Boolean {
        return _isPlayingMusic;
    }

    public function get isPlayingSound():Boolean {
        return _isPlayingSound;
    }

}
}