/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class SmallCatPet  extends PetMain {
    public function SmallCatPet(dPet:StructureDataPet) {
        super(dPet);

        _innerPosX1 = -36 * g.scaleFactor;
        _innerPosY1 = 46 * g.scaleFactor;
        _innerPosX2 = 52 * g.scaleFactor;
        _innerPosY2 = 94 * g.scaleFactor;
    }

    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 4: // kakao_cat_small
                _animation.changeTexture("coffee_cat_head_front_small.png",         "kakao_cat_head_front_small", true);
                _animation.changeTexture("coffee_cat_body_front_small.png",         "kakao_cat_body_front_small", true);
                _animation.changeTexture("coffee_cat_first_leg_L_small_front.png",  "kakao_cat_first_leg_L_small_front", true);
                _animation.changeTexture("coffee_cat_second_leg_L_small_front.png", "kakako_cat_second_leg_R_small_front", true);
                _animation.changeTexture("coffee_cat_first_leg_R_small_front.png",  "kakako_cat_first_leg_R_small_front", true);
                _animation.changeTexture("coffee_cat_second_leg_R_small_front.png", "kakao_cat_second_leg_L_small_front", true);
                _animation.changeTexture("coffee_cat_tail-end_front_small.png",     "kakao_cat_tail-end_front_small", true);
                _animation.changeTexture("cheek",                                   "kakao_cat_small_cheek", true);
                _animation.changeTexture("cheek copy",                              "kakao_cat_small_cheek", true);
                _animation.changeTexture("coffee_cat_eye.png",                      "kakao_cat_eye", true);
                _animation.changeTexture("coffee_cat_eye.png copy",                 "kakao_cat_eye", true);
                _animation.changeTexture("eyes closed",                             "kakao_cat_сlosed_eyes_small", true);
                _animation.changeTexture("coffee_cat_head_back_small",              "kakao_cat_head_back_small", false);
                _animation.changeTexture("coffee_cat_body_back_small",              "kakao_cat_body_back_small", false);
                _animation.changeTexture("coffee_cat_first_leg_R_small_back",       "kakako_cat_first_leg_R_small_back", false);
                _animation.changeTexture("coffee_cat_second_leg_R_small_back",      "kakako_cat_second_leg_R_small_back", false);
                _animation.changeTexture("coffee_cat_first_leg_L_small_back",       "kakao_cat_first_leg_L_small_back", false);
                _animation.changeTexture("coffee_cat_second_leg_L_small_back",      "kakao_cat_second_leg_L_small_back", false);
                _animation.changeTexture("coffee_cat_tail-end_back_small",          "kakao_cat_tail-end_back_small", false);
                break;
            case 13: // coffee_cat_small
                _animation.changeTexture("coffee_cat_head_front_small.png",         "coffee_cat_head_front_small", true);
                _animation.changeTexture("coffee_cat_body_front_small.png",         "coffee_cat_body_front_small", true);
                _animation.changeTexture("coffee_cat_first_leg_L_small_front.png",  "coffee_cat_first_leg_L_small_front", true);
                _animation.changeTexture("coffee_cat_second_leg_L_small_front.png", "coffee_cat_second_leg_R_small_front", true);
                _animation.changeTexture("coffee_cat_first_leg_R_small_front.png",  "coffee_cat_first_leg_R_small_front", true);
                _animation.changeTexture("coffee_cat_second_leg_R_small_front.png", "coffee_cat_second_leg_L_small_front", true);
                _animation.changeTexture("coffee_cat_tail-end_front_small.png",     "coffee_cat_tail-end_front_small", true);
                _animation.changeTexture("cheek",                                   "coffee_cat_small_cheek", true);
                _animation.changeTexture("cheek copy",                              "coffee_cat_small_cheek", true);
                _animation.changeTexture("coffee_cat_eye.png",                      "coffee_cat_eye", true);
                _animation.changeTexture("coffee_cat_eye.png copy",                 "coffee_cat_eye", true);
                _animation.changeTexture("eyes closed",                             "coffee_cat_сlosed_eyes_front_small", true);
                _animation.changeTexture("coffee_cat_head_back_small",              "coffee_cat_head_back_small", false);
                _animation.changeTexture("coffee_cat_body_back_small",              "coffee_cat_body_back_small", false);
                _animation.changeTexture("coffee_cat_first_leg_R_small_back",       "coffee_cat_first_leg_R_small_back", false);
                _animation.changeTexture("coffee_cat_second_leg_R_small_back",      "coffee_cat_second_leg_R_small_back", false);
                _animation.changeTexture("coffee_cat_first_leg_L_small_back",       "coffee_cat_first_leg_L_small_back", false);
                _animation.changeTexture("coffee_cat_second_leg_L_small_back",      "coffee_cat_second_leg_L_small_back", false);
                _animation.changeTexture("coffee_cat_tail-end_back_small",          "coffee_cat_tail-end_back_small", false);
                break;
            case 14: // milk_cat_small
                _animation.changeTexture("coffee_cat_head_front_small.png",         "milk_cat_head_front_small", true);
                _animation.changeTexture("coffee_cat_body_front_small.png",         "milk_cat_body_front_small", true);
                _animation.changeTexture("coffee_cat_first_leg_L_small_front.png",  "milk_cat_first_leg_L_small_front", true);
                _animation.changeTexture("coffee_cat_second_leg_L_small_front.png", "milk_cat_second_leg_R_small_front", true); //
                _animation.changeTexture("coffee_cat_first_leg_R_small_front.png",  "milk_cat_first_leg_R_small_front", true);
                _animation.changeTexture("coffee_cat_second_leg_R_small_front.png", "milk_cat_second_leg_L_small_front", true); //
                _animation.changeTexture("coffee_cat_tail-end_front_small.png",     "milk_cat_tail-end_front_small", true);
                _animation.changeTexture("cheek",                                   "milk_cat_small_cheek", true);
                _animation.changeTexture("cheek copy",                              "milk_cat_small_cheek", true);
                _animation.changeTexture("coffee_cat_eye.png",                      "milk_cat_eye", true); //
                _animation.changeTexture("coffee_cat_eye.png copy",                 "milk_cat_eye", true); //
                _animation.changeTexture("eyes closed",                             "milk_cat_сlosed_eyes_small", true);
                _animation.changeTexture("coffee_cat_head_back_small",              "milk_cat_head_back_small", false);
                _animation.changeTexture("coffee_cat_body_back_small",              "milk_cat_body_back_small", false);
                _animation.changeTexture("coffee_cat_first_leg_R_small_back",       "milk_cat_first_leg_R_small_back", false);
                _animation.changeTexture("coffee_cat_second_leg_R_small_back",      "milk_cat_second_leg_R_small_back", false);
                _animation.changeTexture("coffee_cat_first_leg_L_small_back",       "milk_cat_first_leg_L_small_back", false);
                _animation.changeTexture("coffee_cat_second_leg_L_small_back",      "milk_cat_second_leg_L_small_back", false);
                _animation.changeTexture("coffee_cat_tail-end_back_small",          "milk_cat_tail-end_back_small", false);
                break;
        }
        super.releaseTexture();
    }

    public function clearIt():void {
        deleteIt();
    }
}
}
