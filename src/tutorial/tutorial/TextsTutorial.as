package tutorial.tutorial {
import manager.Vars;

public class TextsTutorial {
    private var _objText:Object;
    private var g:Vars = Vars.getInstance();

    public function TextsTutorial() {
        _objText = {};
        _objText['next'] = String(g.managerLanguage.allTexts[541]);
        _objText['ok'] = String(g.managerLanguage.allTexts[532]);

        _objText[2] = {};
        _objText[2][0] = String(g.managerLanguage.allTexts[542]);//'Приветствую тебя user_name в Долине Рукоблудия! В чем же грех твой столь велик?';

        _objText[3] = {};
        _objText[3][0] = String(g.managerLanguage.allTexts[543]);//'Соберите же пшеничку, господа';
        _objText[3][1] = String(g.managerLanguage.allTexts[544]);//'Коси газон!';

        _objText[4] = {};
        _objText[4][0] = String(g.managerLanguage.allTexts[545]);//'Копал, да? Теперь назад закапывай!';
        _objText[4][1] = String(g.managerLanguage.allTexts[546]);//'Давай-давай!';

        _objText[5] = {};
        _objText[5][0] = String(g.managerLanguage.allTexts[547]);//'1 == 2';
        
        _objText[6] = {};
        _objText[6][1] = String(g.managerLanguage.allTexts[548]);//'Курыыыыы! Купи!!!!';

        _objText[7] = {};
        _objText[7][0] = String(g.managerLanguage.allTexts[550]); //'Давай покормим мы кур, давай-давай';

         _objText[8] = {};
        _objText[8][0] = String(g.managerLanguage.allTexts[551]);//'Уменьшим срок созревания плода до 0!';

        _objText[9] = {};
        _objText[9][0] = String(g.managerLanguage.allTexts[552]); //'Собери яйца!';

        _objText[10] = {};
        _objText[10][0] = String(g.managerLanguage.allTexts[553]); //'Купи Булочную';

        _objText[11] = {};
        _objText[11][1] = String(g.managerLanguage.allTexts[554]);//'Ускорь постройку';

        _objText[12] = {};
        _objText[12][1] = String(g.managerLanguage.allTexts[555]);//'Открой коробочку';

        _objText[13] = {};
        _objText[13][0] = String(g.managerLanguage.allTexts[556]);//'Вот такое вот это оно все';
        _objText[13][1] = String(g.managerLanguage.allTexts[557]);//'Покликай давай!';

        _objText[14] = {};
        _objText[14][0] = String(g.managerLanguage.allTexts[558]);//'Бери булочку';

        _objText[15] = {};
        _objText[15][0] = String(g.managerLanguage.allTexts[559]);//'Купи Кормилку, бро';

        _objText[16] = {};
        _objText[16][0] = String(g.managerLanguage.allTexts[560]);//'Скопай пару грядок';

        _objText[17] = {};
        _objText[17][0] = String(g.managerLanguage.allTexts[561]);//'Посади что-то';

        _objText[18] = {};
        _objText[18][2] = String(g.managerLanguage.allTexts[562]);//'Что за винни-пухи?';
        
        _objText[19] = {};
        _objText[19][0] = String(g.managerLanguage.allTexts[563]);//'Ну, как-то так вот';
    }

    public function get objText():Object {
        return _objText;
    }
}
}
