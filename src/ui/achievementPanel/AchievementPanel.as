/**
 * Created by user on 3/30/17.
 */
package ui.achievementPanel {
import data.BuildType;

import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;
import utils.Utils;

import windows.WOComponents.ProgressBarComponent;

public class AchievementPanel {
    private  var _source:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _txtText:CTextField;
    private var _txtAchiement:CTextField;
    private var _bg:Image;
    private var _timer:int;
    public var show:Boolean;
    public function AchievementPanel() {
        _source = new Sprite();
        _bg = new Image(g.allData.atlas['achievementAtlas'].getTexture('achievement_notification'));
        _source.addChild(_bg);
        g.cont.interfaceCont.addChild(_source);
        _source.visible = false;
        _timer = 0;
        onResize();
        show = false;
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth/2 - _source.width/2;
    }

    public function showIt(ob:Object):void {
        var f1:Function = function():void {
            show = true;
            _source.visible = true;
            _txtText = new CTextField(435, 60, String(g.managerLanguage.allTexts[984]));
            _txtText.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
            _txtText.y = 12;
            _txtText.x = 40;
            _source.addChild(_txtText);
            _txtAchiement = new CTextField(435, 60, ob.name);
            _txtAchiement.setFormat(CTextField.BOLD24, 22, ManagerFilters.YELLOW_COLOR);
            _txtAchiement.y = 38;
            _txtAchiement.x = 40;
            _source.addChild(_txtAchiement);
            g.gameDispatcher.addToTimer(timerEnd);
            for (var i:int = 0; i < g.managerAchievement.userAchievement.length; i++) {
                if (ob.id == g.managerAchievement.userAchievement.id) {
                    var st:String = String(g.managerAchievement.userAchievement[i].tookGift[0]) + '&' + String(g.managerAchievement.userAchievement[i].tookGift[1]) + '&' + String(g.managerAchievement.userAchievement[i].tookGift[2]);
                    g.directServer.updateUserAchievement(g.managerAchievement.userAchievement[i].id, g.managerAchievement.userAchievement[i].resourceCount, st, 1, null);
                }
            }
            var arr:Array = g.townArea.getCityObjectsByType(BuildType.ACHIEVEMENT);
            if (g.managerAchievement.checkAchievement()) arr[0].onTimer();
            else arr[0].onTimer(false);
        };
        if (!g.craftPanel.isShow) f1();
        else Utils.createDelay(4,f1);
    }

    private function timerEnd():void {
        _timer++;
        if (_timer >= 3) {
            g.gameDispatcher.removeFromTimer(timerEnd);
            _timer = 0;
            if (_txtText) {
                _source.removeChild(_txtText);
                _txtText.deleteIt();
                _txtText = null;
            }
            if (_txtAchiement) {
                _source.removeChild(_txtAchiement);
                _txtAchiement.deleteIt();
                _txtAchiement = null;
            }
            show = false;
            _source.visible = false;
        }
    }
}
}
