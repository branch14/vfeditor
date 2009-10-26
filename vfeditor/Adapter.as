package vfeditor {

    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;

    public class Adapter {

        // ------------------------------------------------------------
        //   P R O P E R T I E S

        private var _config:Object;

        // ------------------------------------------------------------
        //   C O N S T R U C T O R   ( S I N G L E T O N )

        private static var _adapter:Adapter;

        public function Adapter(config:Object) {
            this._config = config;
        }

        public static function instance(config:Object = null):Adapter {
            if(!_adapter) {
                _adapter = new Adapter(config);
            }
            return _adapter;
        }

        // ------------------------------------------------------------
        //   M A N D A T O R Y   M E T H O D S

        // GET /my_grammars
        public function myGrammars(result:Function, fault:Function):void {
            _requestGet('/my_grammars', null, result, fault);
        }

        // GET /load_grammar/:id
        public function loadGrammar(id:int, result:Function, fault:Function):void {
            _requestGet('/load_grammar/'+id, null, result, fault);
        }

        // POST /save_grammar/:id
        public function saveGrammar(id:int, title:String, content:String,
            result:Function, fault:Function):void {
            var data:Array = new Array();
            data.push('grammar[title]='+title);
            data.push('grammar[content]='+content);
            _requestPost('/save_grammar/'+id, data, result, fault);
        }

        // GET /generate/:id
        public function generate(id:int, result:Function, fault:Function):void {
            _requestGet('/generate/'+id, null, result, fault);
        }

        // POST /new_group_with_fragments
        public function newGroupWithFragments(title:String, key:String, description:String,
            extendable:Boolean, fragments:Array,
            result:Function, fault:Function):void {
            var data:Array = new Array;
            data.push('group[title]='+title);
            data.push('group[key]='+key);
            data.push('group[description]='+description);
            data.push('group[extendable]='+extendable);
            for each (var fragment:String in fragments) {
                data.push("fragments[]="+fragment);
            }
            _requestPost('/new_group_with_fragments', data, result, fault);
        }

        // POST /extend_group_with_fragments/:id
        public function extendGroupWithFragments(id:int, fragments:Array,
            result:Function, fault:Function):void {
            var data:Array = new Array;
            for each (var fragment:String in fragments) {
                data.push("fragments[]="+fragment);
            }
            _requestPost('/extend_group_with_fragments/'+id, data, result, fault);
        }

        // POST /groups_for_fragments
        public function groupsForFragments(fragments:Array,
            result:Function, fault:Function):void {
            var data:Array = new Array;
            for each (var fragment:String in fragments) {
                data.push('fragments[]='+fragment);
            }
            _requestPost('/groups_for_fragments', data, result, fault);
        }

        // ------------------------------------------------------------
        //   O P T I O N A L   M E T H O D S

        // GET /validate_uniqeness_of_group_key/:id
        public function validateUniqenessOfGroupKey(key:String,
            result:Function, fault:Function):void {
        }

        // GET /fragments_from/:id
        public function fragmentsFrom(id:int, result:Function, fault:Function):void {
        }

        // ------------------------------------------------------------
        //   P R I V A T E   M E T H O D S

        private function _buildLoader(result:Function, fault:Function):URLLoader {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE,
                function(event:Event):void {
                    var raw:String = String(URLLoader(event.target).data);
                    var xmlData:XML = new XML(raw);
                    result(xmlData);
                });
            return loader;
        }

        private function _requestGet(path:String, data:Array,
            result:Function, fault:Function):void {
            var loader:URLLoader = _buildLoader(result, fault);
            var url:String = _config.baseUrl+path;
            if(data) {
                url += "?"+data.join("&");
            }
            loader.load(new URLRequest(url));
        }

        private function _requestPost(path:String, data:Array,
            result:Function, fault:Function):void {
            var loader:URLLoader = _buildLoader(result, fault);
            var request:URLRequest = new URLRequest(_config.baseUrl+path);
            request.method = URLRequestMethod.POST;
            request.data = data.join("&");
            loader.load(request);
        }

    }

}
