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
        _objText[2][0] = String(g.managerLanguage.allTexts[542]);//Добро пожаловать user_name! Я - Тим! Сейчас я тебе все покажу!

        _objText[3] = {};
        _objText[3][0] = String(g.managerLanguage.allTexts[543]);//Сбор Пшеницы
        _objText[3][1] = String(g.managerLanguage.allTexts[544]);//Давай соберем урожай пшеницы!

        _objText[4] = {};
        _objText[4][0] = String(g.managerLanguage.allTexts[545]);//Посадка семян
        _objText[4][1] = String(g.managerLanguage.allTexts[546]);//Давай снова засеем грядки пшеницей! Без нее в хозяйстве не обойтись!

        _objText[5] = {};
        _objText[5][0] = String(g.managerLanguage.allTexts[547]);//Сажаешь одно растение - получаешь два, сажаешь два - получаешь четыре!  Все просто!
        
        _objText[6] = {};
        _objText[6][1] = String(g.managerLanguage.allTexts[548]);//Прекрасно справляешься! Время познакомится с животными!

        _objText[7] = {};
        _objText[7][0] = String(g.managerLanguage.allTexts[550]); //А теперь давай покормим курочек кормом!

         _objText[8] = {};
        _objText[8][0] = String(g.managerLanguage.allTexts[551]);//Чтобы курочка снеслась быстрее, кликни на нее и выбери “ускорить”!

        _objText[9] = {};
        _objText[9][0] = String(g.managerLanguage.allTexts[552]); //Сбор Яиц

        _objText[10] = {};
        _objText[10][0] = String(g.managerLanguage.allTexts[553]); //Теперь займемся производством, купим в магазине Булочную!

        _objText[11] = {};
        _objText[11][1] = String(g.managerLanguage.allTexts[554]);//Не будем ждать! Построим Булочную сейчас! Нажми на стройку, и кликни кнопку “ускорить”!

        _objText[12] = {};
        _objText[12][1] = String(g.managerLanguage.allTexts[555]);//Поздравляю! Ты построил первую фабрику! Перережь скорее ленточку!

        _objText[13] = {};
        _objText[13][0] = String(g.managerLanguage.allTexts[556]);//Выпечка Булок
        _objText[13][1] = String(g.managerLanguage.allTexts[557]);//Давай испечем вкусных булочек!

        _objText[14] = {};
        _objText[14][0] = String(g.managerLanguage.allTexts[558]);//Давай ускорим приготовление Булочек! Нажми кнопку “ускорить”!
        _objText[14][1] = String(g.managerLanguage.allTexts[559]);//У тебя хорошо получается, булочки готовы!

        _objText[15] = {};
        _objText[15][0] = String(g.managerLanguage.allTexts[560]);//Давай построим Кормилку! С этой фабрикой наш животные никогда не будут голодными!

        _objText[16] = {};
        _objText[16][0] = String(g.managerLanguage.allTexts[561]);//Нам нужны еще грядки! Больше грядок - больше урожая!

        _objText[17] = {};
        _objText[17][0] = String(g.managerLanguage.allTexts[562]);//Давай посадим на грядках еще больше различных  растений!
        
        _objText[18] = {};
        _objText[18][2] = String(g.managerLanguage.allTexts[563]);//Пришло время познакомится с нашими постоянными покупателями - няшиками!

//        _objText[19] = {};
//        _objText[19][0] = String(g.managerLanguage.allTexts[564]);//Привет! Мы - покупатели - няшики! У нас, для тебя, всегда есть выгодные предложения!

        _objText[19] = {};
        _objText[19][0] = String(g.managerLanguage.allTexts[565]);//Молодец! Ты отлично справляешься! Занимайся хозяйством: собирай урожай, корми животных,  выполняй заказы няшиков!
    }

    public function get objText():Object {
        return _objText;
    }
}
}
