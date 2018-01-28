/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class CatPet extends PetMain {
    public function CatPet(dPet:StructureDataPet) {
        super(dPet);
        
        _innerPosX1 = -36 * g.scaleFactor;
        _innerPosY1 = 44 * g.scaleFactor;
        _innerPosX2 = -108 * g.scaleFactor;
        _innerPosY2 = 80 * g.scaleFactor;
        _innerPosX3 = 72 * g.scaleFactor;
        _innerPosY3 = 82 * g.scaleFactor;
    }
    
    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 3: // kakao_cat_big
                _animation.changeTexture("coffee_cat_head_front_big.png",         "kakao_cat_head_front_big", true);
                _animation.changeTexture("coffee_cat_body_front_big.png",         "kakao_cat_body_front_big", true);
                _animation.changeTexture("coffee_cat_first_leg_L_big_front.png",  "kakao_cat_first_leg_L_big_front", true);
                _animation.changeTexture("coffee_cat_second_leg_L_big_front.png", "kakako_cat_second_leg_R_big_front", true);
                _animation.changeTexture("coffee_cat_first_leg_R_big_front.png",  "kakako_cat_first_leg_R_big_front", true);
                _animation.changeTexture("coffee_cat_second_leg_R_big_front.png", "kakao_cat_second_leg_L_big_front", true);
                _animation.changeTexture("coffee_cat_tail-end_front_big.png",     "kakao_cat_tail-end_front_big", true);
                _animation.changeTexture("cheek",                                   "kakao_cat_big_cheek", true);
                _animation.changeTexture("cheek copy",                              "kakao_cat_big_cheek", true);
                _animation.changeTexture("coffee_cat_eye.png",                      "kakao_cat_eye", true); 
                _animation.changeTexture("coffee_cat_eye.png copy",                 "kakao_cat_eye", true); 
                _animation.changeTexture("eyes closed",                             "kakao_cat_сlosed_eyes_big", true);
                _animation.changeTexture("coffee_cat_head_back_big",              "kakao_cat_head_back_big", false);
                _animation.changeTexture("coffee_cat_body_back_big",              "kakao_cat_body_back_big", false);
                _animation.changeTexture("coffee_cat_first_leg_R_big_back",       "kakako_cat_first_leg_R_big_back", false);
                _animation.changeTexture("coffee_cat_second_leg_R_big_back",      "kakako_cat_second_leg_R_big_back", false);
                _animation.changeTexture("coffee_cat_first_leg_L_big_back",       "kakao_cat_first_leg_L_big_back", false);
                _animation.changeTexture("coffee_cat_second_leg_L_big_back",      "kakao_cat_second_leg_L_big_back", false);
                _animation.changeTexture("coffee_cat_tail-end_back_big",          "kakao_cat_tail-end_back_big", false);
                break;
            case 11: // coffee_cat_big
                _animation.changeTexture("coffee_cat_head_front_big.png",         "coffee_cat_head_front_big", true);
                _animation.changeTexture("coffee_cat_body_front_big.png",         "coffee_cat_body_front_big", true);
                _animation.changeTexture("coffee_cat_first_leg_L_big_front.png",  "coffee_cat_first_leg_L_big_front", true);
                _animation.changeTexture("coffee_cat_second_leg_L_big_front.png", "coffee_cat_second_leg_R_big_front", true);
                _animation.changeTexture("coffee_cat_first_leg_R_big_front.png",  "coffee_cat_first_leg_R_big_front", true);
                _animation.changeTexture("coffee_cat_second_leg_R_big_front.png", "coffee_cat_second_leg_L_big_front", true);
                _animation.changeTexture("coffee_cat_tail-end_front_big.png",     "coffee_cat_tail-end_front_big", true);
                _animation.changeTexture("cheek",                                   "coffee_cat_big_cheek", true);
                _animation.changeTexture("cheek copy",                              "coffee_cat_big_cheek", true);
                _animation.changeTexture("coffee_cat_eye.png",                      "coffee_cat_eye", true);
                _animation.changeTexture("coffee_cat_eye.png copy",                 "coffee_cat_eye", true);
                _animation.changeTexture("eyes closed",                             "coffee_cat_сlosed_eyes_front_big", true);
                _animation.changeTexture("coffee_cat_head_back_big",              "coffee_cat_head_back_big", false);
                _animation.changeTexture("coffee_cat_body_back_big",              "coffee_cat_body_back_big", false);
                _animation.changeTexture("coffee_cat_first_leg_R_big_back",       "coffee_cat_first_leg_R_big_back", false);
                _animation.changeTexture("coffee_cat_second_leg_R_big_back",      "coffee_cat_second_leg_R_big_back", false);
                _animation.changeTexture("coffee_cat_first_leg_L_big_back",       "coffee_cat_first_leg_L_big_back", false);
                _animation.changeTexture("coffee_cat_second_leg_L_big_back",      "coffee_cat_second_leg_L_big_back", false);
                _animation.changeTexture("coffee_cat_tail-end_back_big",          "coffee_cat_tail-end_back_big", false);
                break;
            case 12: // milk_cat_big
                _animation.changeTexture("coffee_cat_head_front_big.png",         "milk_cat_head_front_big", true);
                _animation.changeTexture("coffee_cat_body_front_big.png",         "milk_cat_body_front_big", true);
                _animation.changeTexture("coffee_cat_first_leg_L_big_front.png",  "milk_cat_first_leg_L_big_front", true);
                _animation.changeTexture("coffee_cat_second_leg_L_big_front.png", "milk_cat_second_leg_R_big_front", true);
                _animation.changeTexture("coffee_cat_first_leg_R_big_front.png",  "milk_cat_first_leg_R_big_front", true);
                _animation.changeTexture("coffee_cat_second_leg_R_big_front.png", "milk_cat_second_leg_L_big_front", true);
                _animation.changeTexture("coffee_cat_tail-end_front_big.png",     "milk_cat_tail-end_front_big", true);
                _animation.changeTexture("cheek",                                   "milk_cat_big_cheek", true);
                _animation.changeTexture("cheek copy",                              "milk_cat_big_cheek", true);
                _animation.changeTexture("coffee_cat_eye.png",                      "milk_cat_eye", true);
                _animation.changeTexture("coffee_cat_eye.png copy",                 "milk_cat_eye", true);
                _animation.changeTexture("eyes closed",                             "milk_cat_сlosed_eyes_big", true);
                _animation.changeTexture("coffee_cat_head_back_big",              "milk_cat_head_back_big", false);
                _animation.changeTexture("coffee_cat_body_back_big",              "milk_cat_body_back_big", false);
                _animation.changeTexture("coffee_cat_first_leg_R_big_back",       "milk_cat_first_leg_R_big_back", false);
                _animation.changeTexture("coffee_cat_second_leg_R_big_back",      "milk_cat_second_leg_R_big_back", false);
                _animation.changeTexture("coffee_cat_first_leg_L_big_back",       "milk_cat_first_leg_L_big_back", false);
                _animation.changeTexture("coffee_cat_second_leg_L_big_back",      "milk_cat_second_leg_L_big_back", false);
                _animation.changeTexture("coffee_cat_tail-end_back_big",          "milk_cat_tail-end_back_big", false);
                break;
        }
        super.releaseTexture();
    }

    public function clearIt():void {
        deleteIt();
    }
}
}
