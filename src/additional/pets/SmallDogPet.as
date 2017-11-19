/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class SmallDogPet extends PetMain  {
    public function SmallDogPet(dPet:StructureDataPet) {
        super(dPet);

        _innerPosX1 = -46 * g.scaleFactor;
        _innerPosY1 = 58 * g.scaleFactor;
        _innerPosX2 = 44 * g.scaleFactor;
        _innerPosY2 = 106 * g.scaleFactor;
    }

    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 2: // pink_dog_small
                changeTexture("Orange_head_small_front.png",             "Pink_head_small_front", _armature);
                changeTexture("Orange_body_small_front.png",             "Pink_body_small_front", _armature);
                changeTexture("Orange_first_L_leg_small_front.png",      "Pink_first_L_leg_small_front", _armature);
                changeTexture("Orange_second_L_leg_small_front.png",     "Pink_second_R_leg_small_front", _armature);
                changeTexture("Orange_first_R_leg_small_front.png",      "Pink_first_R_leg_small_front", _armature);
                changeTexture("Orange_second_R_leg_small_front.png",     "Pink_second_L_leg_small_front", _armature);
                changeTexture("Orange_tail-end_small_front.png",         "Pink_tail-end_small_front", _armature);
//                changeTexture("Layer 3",                             "kakao_cat_сlosed_eyes_small", _armature);
                changeTexture("Orange_head_small_back.png",              "Pink_head_small_back", _armatureBack);
                changeTexture("Orange_body_small_back.png",              "Pink_body_small_back", _armatureBack);
                changeTexture("Orange_first_R_leg_small_back.png",       "Pink_first_R_leg_small_back", _armatureBack);
                changeTexture("Orange_second_R_leg_small_back.png",      "Pink_second_R_leg_small_back", _armatureBack);
                changeTexture("Orange_first_L_leg_small_back.png",       "Pink_first_L_leg_small_back", _armatureBack);
                changeTexture("Orange_second_L_leg_small_back.png",      "Pink_second_L_leg_small_back", _armatureBack);
                changeTexture("Orange_second_R_leg_small_back.png",      "Pink_second_R_leg_small_back", _armatureBack);
                changeTexture("Orange_tail-end_small_back.png",          "Pink_tail-end_small_back", _armatureBack);
                break;
            case 9: // red_dog_small
                changeTexture("Orange_head_small_front.png",             "Orange_head_small_front", _armature);
                changeTexture("Orange_body_small_front.png",             "Orange_body_small_front", _armature);
                changeTexture("Orange_first_L_leg_small_front.png",      "Orange_first_L_leg_small_front", _armature);
                changeTexture("Orange_second_L_leg_small_front.png",     "Orange_second_R_leg_small_front", _armature);
                changeTexture("Orange_first_R_leg_small_front.png",      "Orange_first_R_leg_small_front", _armature);
                changeTexture("Orange_second_R_leg_small_front.png",     "Orange_second_L_leg_small_front", _armature);
                changeTexture("Orange_tail-end_small_front.png",         "Orange_tail-end_small_front", _armature);
//                changeTexture("Layer 3",                             "kakao_cat_сlosed_eyes_small", _armature);
                changeTexture("Orange_head_small_back.png",              "Orange_head_small_back", _armatureBack);
                changeTexture("Orange_body_small_back.png",              "Orange_body_small_back", _armatureBack);
                changeTexture("Orange_first_R_leg_small_back.png",       "Orange_first_R_leg_small_back", _armatureBack);
                changeTexture("Orange_second_R_leg_small_back.png",      "Orange_second_R_leg_small_back", _armatureBack);
                changeTexture("Orange_first_L_leg_small_back.png",       "Orange_first_L_leg_small_back", _armatureBack);
                changeTexture("Orange_second_L_leg_small_back.png",      "Orange_second_L_leg_small_back", _armatureBack);
                changeTexture("Orange_second_R_leg_small_back.png",      "Orange_second_R_leg_small_back", _armatureBack);
                changeTexture("Orange_tail-end_small_back.png",          "Orange_tail-end_small_back", _armatureBack);
                break;
            case 10: // grey_dog_small
                changeTexture("Orange_head_small_front.png",             "Grey_head_small_front", _armature);
                changeTexture("Orange_body_small_front.png",             "Grey_body_small_front", _armature);
                changeTexture("Orange_first_L_leg_small_front.png",      "Grey_first_L_leg_small_front", _armature);
                changeTexture("Orange_second_L_leg_small_front.png",     "Grey_second_R_leg_small_front", _armature);
                changeTexture("Orange_first_R_leg_small_front.png",      "Grey_first_R_leg_small_front", _armature);
                changeTexture("Orange_second_R_leg_small_front.png",     "Grey_second_L_leg_small_front", _armature);
                changeTexture("Orange_tail-end_small_front.png",         "Grey_tail-end_small_front", _armature);
//                changeTexture("Layer 3",                             "kakao_cat_сlosed_eyes_small", _armature);
                changeTexture("Orange_head_small_back.png",              "Grey_head_small_back", _armatureBack);
                changeTexture("Orange_body_small_back.png",              "Grey_body_small_back", _armatureBack);
                changeTexture("Orange_first_R_leg_small_back.png",       "Grey_first_R_leg_small_back", _armatureBack);
                changeTexture("Orange_second_R_leg_small_back.png",      "Grey_second_R_leg_small_back", _armatureBack);
                changeTexture("Orange_first_L_leg_small_back.png",       "Grey_first_L_leg_small_back", _armatureBack);
                changeTexture("Orange_second_L_leg_small_back.png",      "Grey_second_L_leg_small_back", _armatureBack);
                changeTexture("Orange_second_R_leg_small_back.png",      "Grey_second_R_leg_small_back", _armatureBack);
                changeTexture("Orange_tail-end_small_back.png",          "Grey_tail-end_small_back", _armatureBack);
                break;
        }
        super.releaseTexture();
    }
}
}
