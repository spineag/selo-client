/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package loaders {
import data.AllData;
import manager.*;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;

public class EmbedAssets {
    // Texture
//    [Embed(source="../../assets/interfaceAtlas.png")]
//    private const InterfaceTexture:Class;
    // XML
//    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
//    private const InterfaceTextureXML:Class;

//    [Embed(source="../../assets/fonts/BloggerSansMediumRegular.otf", embedAsCFF="false", fontName="BloggerMedium")]
//    private const BloggerMedium:Class;

    [Embed(source="../../assets/fonts/bitmap/bold30.png")]
    private const BitmapBloggerBoldWhite30png:Class;
    [Embed(source="../../assets/fonts/bitmap/bold30.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite30xml:Class;
    [Embed(source="../../assets/fonts/bitmap/bold24_1.png")]
    private const BitmapBloggerBoldWhite24png:Class;
    [Embed(source="../../assets/fonts/bitmap/bold24_1.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite24xml:Class;
    [Embed(source="../../assets/fonts/bitmap/bold18_5.png")]
    private const BitmapBloggerBoldWhite18png:Class;
    [Embed(source="../../assets/fonts/bitmap/bold18_5.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite18xml:Class;
    [Embed(source="../../assets/fonts/bitmap/medium30.png")]
    private const BitmapBloggerMediumWhite30png:Class;
    [Embed(source="../../assets/fonts/bitmap/medium30.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite30xml:Class;
    [Embed(source="../../assets/fonts/bitmap/medium24.png")]
    private const BitmapBloggerMediumWhite24png:Class;
    [Embed(source="../../assets/fonts/bitmap/medium24.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite24xml:Class;
    [Embed(source="../../assets/fonts/bitmap/medium18.png")]
    private const BitmapBloggerMediumWhite18png:Class;
    [Embed(source="../../assets/fonts/bitmap/medium18.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite18xml:Class;
    [Embed(source="../../assets/fonts/bitmap/regular30.png")]
    private const BitmapBloggerRegularWhite30png:Class;
    [Embed(source="../../assets/fonts/bitmap/regular30.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite30xml:Class;
    [Embed(source="../../assets/fonts/bitmap/regular24.png")]
    private const BitmapBloggerRegularWhite24png:Class;
    [Embed(source="../../assets/fonts/bitmap/regular24.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite24xml:Class;
    [Embed(source="../../assets/fonts/bitmap/regular18.png")]
    private const BitmapBloggerRegularWhite18png:Class;
    [Embed(source="../../assets/fonts/bitmap/regular18.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite18xml:Class;
    [Embed(source="../../assets/fonts/bitmap/bold72.png")]
    private const BitmapBloggerBold72png:Class;
    [Embed(source="../../assets/fonts/bitmap/bold72.fnt", mimeType="application/octet-stream")]
    private const BitmapBloggerBold72xml:Class;

    [Embed(source="../../assets/animations/x1/cat_tutorial.png", mimeType = "application/octet-stream")]
    private const CatTutorial:Class;
    [Embed(source="../../assets/animations/x1/cat_tutorial_big.png", mimeType = "application/octet-stream")]
    private const CatTutorialBig:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets(onLoadCallback:Function) {
        g.allData = new AllData();
//        createTexture(onLoadCallback);
        registerFonts();
        if (onLoadCallback != null) {
            onLoadCallback.apply();
            onLoadCallback = null;
        }
    }

    private function registerFonts():void {
        //bFont.smoothing = TextureSmoothing.TRILINEAR;
        var texture:Texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite30png);
        var xml:XML = XML(new BitmapBloggerBoldWhite30xml());
        var bFont:BitmapFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerBold30');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite24png);
        xml = XML(new BitmapBloggerBoldWhite24xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerBold24');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite18png);
        xml = XML(new BitmapBloggerBoldWhite18xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerBold18');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite30png);
        xml = XML(new BitmapBloggerMediumWhite30xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerMedium30');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite24png);
        xml = XML(new BitmapBloggerMediumWhite24xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerMedium24');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite18png);
        xml = XML(new BitmapBloggerMediumWhite18xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerMedium18');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite30png);
        xml = XML(new BitmapBloggerRegularWhite30xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerRegular30');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite24png);
        xml = XML(new BitmapBloggerRegularWhite24xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerRegular24');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite18png);
        xml = XML(new BitmapBloggerRegularWhite18xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerRegular18');

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBold72png);
        xml = XML(new BitmapBloggerBold72xml());
        bFont = new BitmapFont(texture, xml);
        TextField.registerCompositor(bFont, 'BloggerBold72');
    }

//    private function createTexture(onLoadCallback:Function):void {
//        var texture:Texture = Texture.fromBitmap(new ResourceTexture());
//        var xml:XML= XML(new ResourceTextureXML());
//        g.allData.atlas['resourceAtlas'] = new TextureAtlas(texture, xml);
//        texture = Texture.fromBitmap(new BuildTexture());
//        xml= XML(new BuildTextureXML());
//        g.allData.atlas['buildAtlas'] = new TextureAtlas(texture, xml);

        // use this
//        g.allData.fonts['BloggerRegular'] = (new BloggerRegular() as Font).fontName;
//        g.allData.fonts['BloggerMedium'] = (new BloggerMedium() as Font).fontName;
//        g.allData.fonts['BloggerBold'] = (new BloggerBold() as Font).fontName;

//        var count:int = 2;
//        var checkCount:Function = function ():void {
//            count--;
//            if (count <= 0) {
//                if (onLoadCallback != null) {
//                    onLoadCallback.apply();
//                    onLoadCallback = null;
//                }
//            }
//        };
//        loadFactory('tutorialCat', CatTutorial, checkCount);
//        loadFactory('tutorialCatBig', CatTutorialBig, checkCount);
//    }
//
//    private function loadFactory(name:String, clas:Class, onLoad:Function):void {
//        var factory:StarlingFactory = new StarlingFactory();
//        var f:Function = function (e:Event):void {
//            factory.removeEventListener(Event.COMPLETE, f);
//            g.allData.factory[name] = factory;
//            if (onLoad != null) onLoad.apply();
//        };
//        factory.addEventListener(Event.COMPLETE, f);
//        factory.parseDragonBonesData(new clas());
//    }
}
}
