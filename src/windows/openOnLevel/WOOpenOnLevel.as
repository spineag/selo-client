/**
 * Created by user on 2/21/18.
 */
package windows.openOnLevel {
import flash.display.Bitmap;

import manager.ManagerLanguage;

import starling.display.Image;

import starling.textures.Texture;

import windows.WindowMain;
import windows.WindowsManager;

public class WOOpenOnLevel extends WindowMain {
    private var _stURL:String;

    public function WOOpenOnLevel() {
        super ();
        _woWidth = 655;
        _woHeight = 452;
        _windowType = WindowsManager.WO_OPEN_ON_LEVEL;
    }

    override public function showItParams(callback:Function, params:Array):void {
        switch (params[0]) {
            case 'market':
                    if (g.user.language == ManagerLanguage.ENGLISH) _stURL = g.dataPath.getGraphicsPath() + 'qui/farmstand_eng.png';
                    else _stURL = g.dataPath.getGraphicsPath() + 'qui/farmstand_ru.png';
                break;
            case 'paper':
                    if (g.user.language == ManagerLanguage.ENGLISH) _stURL = g.dataPath.getGraphicsPath() + 'qui/newspaper_eng.png';
                    else _stURL = g.dataPath.getGraphicsPath() + 'qui/newspaper_ru.png';
                break;
            case 'dailyBonus':
                    if (g.user.language == ManagerLanguage.ENGLISH) _stURL = g.dataPath.getGraphicsPath() + 'qui/dailybon_eng.png';
                    else _stURL = g.dataPath.getGraphicsPath() + 'qui/dailybon_ru.png';
                break;
            case 'cave':
                    if (g.user.language == ManagerLanguage.ENGLISH) _stURL = g.dataPath.getGraphicsPath() + 'qui/cave_eng.png';
                    else _stURL = g.dataPath.getGraphicsPath() + 'qui/cave_ru.png';
                break;
            case 'train':
                    if (g.user.language == ManagerLanguage.ENGLISH) _stURL = g.dataPath.getGraphicsPath() + 'qui/train_eng.png';
                    else _stURL = g.dataPath.getGraphicsPath() + 'qui/train_ru.png';
                break;
        }
        g.load.loadImage(_stURL, onLoad);
        super.showIt();
    }

    private function onLoad(bitmap:Bitmap):void {
        if (!_source) return;
        bitmap = g.pBitmaps[_stURL].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChild(image);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
    }
}
}
