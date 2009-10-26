package vfeditor {

    import mx.core.Container;
    import mx.controls.TextArea;
    import mx.controls.textClasses.TextRange;

    public class Editor extends Container {

        // ------------------------------------------------------------
        //  P R O P E R T I E S

        public var gid:int;
        private var _textArea:TextArea;

        // ------------------------------------------------------------
        //  C O N S T R U C T O R

        public function Editor(gid:int, title:String, content:String) {
            this.gid = gid;
            this.title = title;
            // FIXME set size to 100%
            //this.content = content;
            //this.width = 320;//this.preferredWidth;
            //this.height = 240;//this.preferredHeight;
            _textArea = new TextArea();
            _textArea.width = 640;//this.preferredWidth;
            _textArea.height = 240;//this.preferredHeight;
            addChild(_textArea);
            this.content = content;
        }

        // ------------------------------------------------------------
        //  M E T H O D S

        [Bindable]
        public function set title(title:String):void {
            this.label = title;
        }

        public function get title():String {
            return this.label;
        }

        [Bindable]
        public function set content(content:String):void {
            _textArea.text = content;
        }

        public function get content():String {
            return _textArea.text;
        }

        public function get selection():String {
            return _textArea.text.substring(_textArea.selectionBeginIndex, _textArea.selectionEndIndex);
        }

        public function replaceSelection(replacement:String):void {
            var text:String = _textArea.text;
            var range:TextRange = new TextRange(_textArea, true);
            var begin:int = range.beginIndex;
            range.text = replacement;
            _textArea.selectionBeginIndex = begin;
            _textArea.selectionEndIndex = begin+replacement.length;
        }

        public function focus():void {
            _textArea.setFocus();
        }

    }

}

