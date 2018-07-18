package social {
import com.adobe.crypto.MD5;
import social.blank.SN_Blank;
import social.blank_FB.SN_Blank_FB;
import social.fb.SN_FB;
import social.ok.SN_OK;
import social.vk.SN_Vkontakte;
import manager.Vars;

public class SocialNetworkSwitch {
    public static var SN_VK_ID:int = 2;
    public static var SN_OK_ID:int = 3;
    public static var SN_FB_ID:int = 4;

    private static var SECRET_KEY_VK:String = '';
    private static var SECRET_KEY:String = '';

    protected static var g:Vars = Vars.getInstance();

    public static function init(channelID:int, flashVars:Object, isDebug:Boolean = true):void {
        switch (channelID) {
            case SN_VK_ID:
                SECRET_KEY = SECRET_KEY_VK;
                if (isDebug) {
                    flashVars["api_id"] = "6360136";
                    flashVars["viewer_id"] = "191561520";
                    flashVars["sid"] = "8524544630161c7e6a736c1d05354eeda7b5a67be95a3374acc0de0f8dc591ca6532cd83e2e2726467e1c";
                    flashVars["secret"] = "698d393d02";
                    g.socialNetwork = new SN_Blank(flashVars);
                    g.user.userSocialId = flashVars["viewer_id"];
                } else {
                    flashVars["access_key"] = MD5.hash(flashVars["api_id"] + flashVars["viewer_id"] + SECRET_KEY);
                    g.socialNetwork = new SN_Vkontakte(flashVars, g.dataPath.getMainPath());
                    g.user.userSocialId = flashVars["viewer_id"];
                }
                break;
            case SN_OK_ID:
                    // Application ID: 1266692864
//                     Публичный ключ приложения: 
//                     Секретный ключ приложения:  EC804AAB7DD4B598C4F2C3C5
//                     Ссылка на приложение: http://www.odnoklassniki.ru/game/...

                if (isDebug) {
                    flashVars["uid"] = "555480938615";
                    g.socialNetwork = new SN_Blank(flashVars);
                } else {
                    flashVars["uid"] = flashVars["logged_user_id"];
                    g.socialNetwork = new SN_OK(flashVars);
                }
                g.user.userSocialId =  flashVars["uid"];
                break;
            case SN_FB_ID:
                if (isDebug) {
                    flashVars["uid"] = "1440177116062575";
                    g.socialNetwork = new SN_Blank_FB(flashVars);
                } else {
                    g.socialNetwork = new SN_FB(flashVars);
                }
                break;
            default:
                break;
        }
    }
}
}