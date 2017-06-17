import dom, jsffi, times

type 
    Option* = ref object of js 
        # VueJS instance options
        el* : cstring
        data* : js
        methods* : js 

type 
    Instance* {.importc.} = ref object of js
        data* {.importc:"$$$1".} :js
        props* {.importc:"$$$1".} :js
        el* {.importc:"$$$1".} : dom.Element
        options* {.importc:"$$$1".} :js
        parent* {.importc:"$$$1".} : Instance
        root* {.importc:"$$$1".} : Instance
        children* {.importc:"$$$1".} :js
        slots* {.importc:"$$$1".} :js
        scopedSlots* {.importc:"$$$1".} :js
        refs* {.importc:"$$$1".} :js
        isServer* {.importc:"$$$1".} : bool

        set* {.importc:"$$$1".} : proc(target:js, key:cstring, val: js) 
        delete* {.importc:"$$$1".} : proc(target:js, key:cstring) 
        watch* {.importc:"$$$1".} : proc(exp:cstring) {.varargs.}
        # event
        on* {.importc:"$$$1".} : proc(event:cstring) {.varargs.}
        emit* {.importc:"$$$1".} : proc(event:cstring) {.varargs.}

type
    configObj* = ref object of js
        slient*: bool
        optionMergeStrategies*: js
        devtools*: bool
        errorHandler*: proc(err, vm, info:js)
        ignoredElements*: seq[string]
        keyCodes*: js
        performance*: bool
        productionTip*: bool

var
    config* {.importc:"Vue.$1".} : configObj
    version* {.importc:"Vue.version".}: cstring

proc newVue*(o: js|Option): Instance {.importcpp:"new Vue(#)"}

{.push importc:"Vue.$1".}
proc extend*(o: js|Option): Instance
proc nextTick*(fn:any): void 
proc set*(target: any, key:cstring, value: any): void  
proc delete*(target: any, key:cstring): void
proc directive*(name: cstring): void {.varargs.}
proc filter*(name: cstring) {.varargs.}
proc component*(name: cstring): void {.varargs.}
proc use*(plugin: js): void  
proc compile*(tmpl: cstring): void
{.pop.}

proc mix*(mix: js): void {.importc:"Vue.mixin(@)".}