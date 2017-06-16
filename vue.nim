import dom, jsffi, times, strutils, future, macros

type 
    Option* = ref object
        el* : cstring
        data* : ref object
        methods* : js 
    Vue* {.importc.} = ref object of JsObject
        data* {.importc:"$$$1".} :JsObject
        props* {.importc:"$$$1".} :JsObject
        el* {.importc:"$$$1".} : dom.Element
        options* {.importc:"$$$1".} :JsObject
        parent* {.importc:"$$$1".} : Vue
        root* {.importc:"$$$1".} : Vue
        children* {.importc:"$$$1".} :JsObject
        slots* {.importc:"$$$1".} :JsObject
        scopedSlots* {.importc:"$$$1".} :JsObject
        refs* {.importc:"$$$1".} :JsObject
        isServer* {.importc:"$$$1".} : bool

        set* {.importc:"$$$1".} : proc(target:JsObject, key:cstring, val: JsObject) 
        delete* {.importc:"$$$1".} : proc(target:JsObject, key:cstring) 
        watch* {.importc:"$$$1".} : proc(exp:cstring) {.varargs.}
        # event
        on* {.importc:"$$$1".} : proc(event:cstring, cb:proc(args: varargs[cstring]))
        emit* {.importc:"$$$1".} : proc(event:cstring, args: varargs[cstring])

var
    slient* {.importc: "Vue.config.$1".} :bool
    optionMergeStrategies* {.importc: "Vue.config.$1".} : JsObject
    devtools* {.importc: "Vue.config.$1".} :bool
    errorHandler* {.importc: "Vue.config.$1".} :proc(err, vm, info:JsObject)
    ignoredElements* {.importc: "Vue.config.$1".} :seq[string]
    keyCodes* {.importc: "Vue.config.$1".} : JsObject
    performance* {.importc: "Vue.config.$1".} :bool
    productionTip* {.importc: "Vue.config.$1".} :bool
    Version* {.importc:"Vue.version".}: cstring

proc newVue*(o: Option): Vue {.importcpp:"new Vue(#)"}

{.push importc:"Vue.$1".}
proc extend*(o: Option): Vue
proc nextTick*(fn:any): void 
proc set*(target: any, key:cstring|SomeInteger, value: any): void  
proc delete*(target: any, key:cstring|SomeInteger): void  
proc directive*(name: cstring, definition: JsObject|proc()): void  
proc filter*(name: cstring) {.varargs.}
proc component*(name: cstring, definition: JsObject): void 
proc use*(plugin: JsObject): void  
proc mix*(mix: JsObject): void  
proc compile*(tmpl: cstring): void
{.pop.}


when isMainModule:
    import jsconsole
    type
        AO = ref object
            str: cstring
            i:int
    console.log(Version)
    filter("upper2", (x:cstring)=> cstring(toUpperAscii($x)))
    # var data = AO{
    var model = AO{
            str:"time: $# $#"%[getDateStr(), getClockStr()],
            i:100,
        }
    # var b = jsnew(Vue)
    var v = newVue(Option(
        el:"#id", 
        data: model,
        methods: js{
            click: proc() = 
                console.log("111")
                model.str = "==============="
                console.log("222")
        }
    ))
    # v.set(v, "a", 1.toJs)
    # var p =  (n, o : js) => console.log(n)
    proc p(n, o:js) = console.log("new value:", n)
    v.watch("str", p)
    console.log(v)
    console.log(v.el)
    console.log(model)

    slient = false
    discard window.setInterval(proc() = 
        model.str = "time: $# $#"%[getDateStr(), getClockStr()],
    1000)

    var a = extend(Option(el:"#id"))
    console.log(a)
    nextTick(()=>log("nextTick123"))
    set(v, cstring("b"), 456)
    console.log("xxxx", "zzzzzzz")