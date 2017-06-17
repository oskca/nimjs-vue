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

when isMainModule:
    import future, strutils
    proc log() {.importcpp:"console.log(@)", varargs.}
    type
        AO = ref object of js
            str: cstring
            i:int
            list: seq[int]
    # vue.filter("upper2", (x:cstring)=> cstring(toUpperAscii($x)))
    # var data = AO{
    var model = AO{
            str:"time: $# $#"%[getDateStr(), getClockStr()],
            i: 100,
            f: 120.879,
            # list: [1,2,3,4],
            list: lc[x*y | (x <- countup(0,10), y<-1..<10), int],
            width: dom.window.screen.width,
            height: dom.window.screen.height,
        }
    # var b = jsnew(Vue)
    var v = newVue(Option(
        el:"#id", 
        data: model,
        methods: js{
            click: proc() = 
                log("111")
                model.str = "==============="
                log("222")
        }
    ))
    # v.set(v, "a", 1.toJs)
    v.watch("str", (n:cstring) => (log(n)))
    log(v)
    log(model)
    # log model.i, model.str, model.f

    vue.config.slient = true
    # discard window.setInterval(proc() = 
    #     model.str = "time: $# $#"%[getDateStr(), getClockStr()],
    # 1000)

    # var a = extend(Option{dataProc:()=>js{a:110}})
    # log(a)
    nextTick(()=>log("nextTick123"))
    # set(v, "b", 456)
    # delete(v, "b", 456)
    log("xxxx", "zzzzzzz")
    config.slient = true    
    log(version)
    window.status = "asdf"
    log(window.status)
    log(dom.navigator.appCodeName, navigator.appName, navigator.userAgent)
