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
        _objText[2][0] = 'Приветствую тебя user_name в Долине Рукоблудия! В чем же грех твой столь велик?';  //String(g.managerLanguage.allTexts[542]);

        _objText[3] = {};
        _objText[3][0] = 'Соберите же пшеничку, господа'; //String(g.managerLanguage.allTexts[543]);
        _objText[3][1] = 'Коси газон!'; //String(g.managerLanguage.allTexts[543]);

        _objText[4] = {};
        _objText[4][0] = 'Копал, да? Теперь назад закапывай!';
        _objText[4][1] = 'Давай-давай!';

        _objText[5] = {};
        _objText[5][0] = '1 == 2'; //String(g.managerLanguage.allTexts[544]);
        
        _objText[6] = {};
        _objText[6][1] = 'Курыыыыы! Купи!!!!'; //String(g.managerLanguage.allTexts[544]);

        _objText[7] = {};
        _objText[7][0] = 'Давай покормим мы кур, давай-давай'; //String(g.managerLanguage.allTexts[545]);

         _objText[8] = {};
        _objText[8][0] = 'Уменьшим срок созревания плода до 0!';

        _objText[9] = {};
        _objText[9][0] = 'Купи Булочную'; //String(g.managerLanguage.allTexts[546]);

        _objText[10] = {};
        _objText[10][1] = 'Ускорь постройку'; //String(g.managerLanguage.allTexts[547]);

        _objText[11] = {};
        _objText[11][1] = 'Открой коробочку'; //String(g.managerLanguage.allTexts[547]);

        _objText[12] = {};
        _objText[12][0] = 'Вот такое вот это оно все';  //String(g.managerLanguage.allTexts[548]);
        _objText[12][1] = 'Покликай давай!';

        _objText[13] = {};
        _objText[13][0] = 'Купи Кормилку, бро';

        _objText[14] = {};
        _objText[14][0] = 'Скопай пару грядок';

        _objText[15] = {};
        _objText[15][0] = 'Посади что-то';

        _objText[16] = {};
        _objText[16][2] = 'Что за винни-пухи?';
        
        _objText[17] = {};
        _objText[17][0] = 'Ну, как-то так вот';
    }

    public function get objText():Object {
        return _objText;
    }
}
}
