/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class SmallCatPet  extends PetMain {
    public function SmallCatPet(dPet:StructureDataPet) {
        super(dPet);
    }

    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 4: // kakao_cat_small
                changeTexture("coffee_cat_head_front_small.png",         "kakao_cat_head_front_small", _armature);
                changeTexture("coffee_cat_body_front_small.png",         "kakao_cat_body_front_small", _armature);
                changeTexture("coffee_cat_first_leg_L_small_front.png",  "kakao_cat_first_leg_L_small_front", _armature);
                changeTexture("coffee_cat_second_leg_L_small_front.png", "kakako_cat_second_leg_R_small_front", _armature);
                changeTexture("coffee_cat_first_leg_R_small_front.png",  "kakako_cat_first_leg_R_small_front", _armature);
                changeTexture("coffee_cat_second_leg_R_small_front.png", "kakao_cat_second_leg_L_small_front", _armature);
                changeTexture("coffee_cat_tail-end_front_small.png",     "kakao_cat_tail-end_front_small", _armature);
                changeTexture("cheek",                                   "kakao_cat_small_cheek", _armature);
                changeTexture("cheek copy",                              "kakao_cat_small_cheek", _armature);
                changeTexture("coffee_cat_eye.png",                      "kakao_cat_eye", _armature);
                changeTexture("coffee_cat_eye.png copy",                 "kakao_cat_eye", _armature);
                changeTexture("eyes closed",                             "kakao_cat_сlosed_eyes_small", _armature);
                changeTexture("coffee_cat_head_back_small",              "kakao_cat_head_back_small", _armatureBack);
                changeTexture("coffee_cat_body_back_small",              "kakao_cat_body_back_small", _armatureBack);
                changeTexture("coffee_cat_first_leg_R_small_back",       "kakako_cat_first_leg_R_small_back", _armatureBack);
                changeTexture("coffee_cat_second_leg_R_small_back",      "kakako_cat_second_leg_R_small_back", _armatureBack);
                changeTexture("coffee_cat_first_leg_L_small_back",       "kakao_cat_first_leg_L_small_back", _armatureBack);
                changeTexture("coffee_cat_second_leg_L_small_back",      "kakao_cat_second_leg_L_small_back", _armatureBack);
                changeTexture("coffee_cat_tail-end_back_small",          "kakao_cat_tail-end_back_small", _armatureBack);
                break;
            case 13: // coffee_cat_small
                changeTexture("coffee_cat_head_front_small.png",         "coffee_cat_head_front_small", _armature);
                changeTexture("coffee_cat_body_front_small.png",         "coffee_cat_body_front_small", _armature);
                changeTexture("coffee_cat_first_leg_L_small_front.png",  "coffee_cat_first_leg_L_small_front", _armature);
                changeTexture("coffee_cat_second_leg_L_small_front.png", "coffee_cat_second_leg_R_small_front", _armature);
                changeTexture("coffee_cat_first_leg_R_small_front.png",  "coffee_cat_first_leg_R_small_front", _armature);
                changeTexture("coffee_cat_second_leg_R_small_front.png", "coffee_cat_second_leg_L_small_front", _armature);
                changeTexture("coffee_cat_tail-end_front_small.png",     "coffee_cat_tail-end_front_small", _armature);
                changeTexture("cheek",                                   "coffee_cat_small_cheek", _armature);
                changeTexture("cheek copy",                              "coffee_cat_small_cheek", _armature);
                changeTexture("coffee_cat_eye.png",                      "coffee_cat_eye", _armature);
                changeTexture("coffee_cat_eye.png copy",                 "coffee_cat_eye", _armature);
                changeTexture("eyes closed",                             "coffee_cat_сlosed_eyes_small", _armature);
                changeTexture("coffee_cat_head_back_small",              "coffee_cat_head_back_small", _armatureBack);
                changeTexture("coffee_cat_body_back_small",              "coffee_cat_body_back_small", _armatureBack);
                changeTexture("coffee_cat_first_leg_R_small_back",       "coffee_cat_first_leg_R_small_back", _armatureBack);
                changeTexture("coffee_cat_second_leg_R_small_back",      "coffee_cat_second_leg_R_small_back", _armatureBack);
                changeTexture("coffee_cat_first_leg_L_small_back",       "coffee_cat_first_leg_L_small_back", _armatureBack);
                changeTexture("coffee_cat_second_leg_L_small_back",      "coffee_cat_second_leg_L_small_back", _armatureBack);
                changeTexture("coffee_cat_tail-end_back_small",          "coffee_cat_tail-end_back_small", _armatureBack);
                break;
            case 14: // milk_cat_small
                changeTexture("coffee_cat_head_front_small.png",         "milk_cat_head_front_small", _armature);
                changeTexture("coffee_cat_body_front_small.png",         "milk_cat_body_front_small", _armature);
                changeTexture("coffee_cat_first_leg_L_small_front.png",  "milk_cat_first_leg_L_small_front", _armature);
                changeTexture("coffee_cat_second_leg_L_small_front.png", "milk_cat_second_leg_R_small_front", _armature);
                changeTexture("coffee_cat_first_leg_R_small_front.png",  "milk_cat_first_leg_R_small_front", _armature);
                changeTexture("coffee_cat_second_leg_R_small_front.png", "milk_cat_second_leg_L_small_front", _armature);
                changeTexture("coffee_cat_tail-end_front_small.png",     "milk_cat_tail-end_front_small", _armature);
                changeTexture("cheek",                                   "milk_cat_small_cheek", _armature);
                changeTexture("cheek copy",                              "milk_cat_small_cheek", _armature);
                changeTexture("coffee_cat_eye.png",                      "milk_cat_eye", _armature);
                changeTexture("coffee_cat_eye.png copy",                 "milk_cat_eye", _armature);
                changeTexture("eyes closed",                             "milk_cat_сlosed_eyes_small", _armature);
                changeTexture("coffee_cat_head_back_small",              "milk_cat_head_back_small", _armatureBack);
                changeTexture("coffee_cat_body_back_small",              "milk_cat_body_back_small", _armatureBack);
                changeTexture("coffee_cat_first_leg_R_small_back",       "milk_cat_first_leg_R_small_back", _armatureBack);
                changeTexture("coffee_cat_second_leg_R_small_back",      "milk_cat_second_leg_R_small_back", _armatureBack);
                changeTexture("coffee_cat_first_leg_L_small_back",       "milk_cat_first_leg_L_small_back", _armatureBack);
                changeTexture("coffee_cat_second_leg_L_small_back",      "milk_cat_second_leg_L_small_back", _armatureBack);
                changeTexture("coffee_cat_tail-end_back_small",          "milk_cat_tail-end_back_small", _armatureBack);
                break;
        }
        super.releaseTexture();
    }
}
}
