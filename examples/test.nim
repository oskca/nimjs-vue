import future, strutils, jsffi, times, dom, ../vue
proc log() {.importcpp:"console.log(@)", varargs.}
type
    AO = ref object of js
        str: cstring
        i: int
        list: seq[(int,int)]
vue.filter("upper2", (x:cstring)=> cstring(toUpperAscii($x)))

newDirective("my-directive", proc(el: Element, b: DirectiveBinding) =
    el.innerHTML = b.value.to(cstring)
)

import sequtils

newComponent("my", ComponentOption{
    tmpl: """
    <div>
        Hello my {{ showName }}
        <button @click="click">MyClick</button>
        <button @click="click2">MyClick2</button>
    </div>
    """,
    props: map(@["showName"], (x)=>cstring(x)),
    methods: js{
        click: ()=>log("component clicked"),
        click2: bindMethod((that:js)=>log("com:", that.showName))
    }
})

# var data = AO{
var model = AO{
    str:"time: $# $#"%[getDateStr(), getClockStr()],
    i: 100,
    f: 120.879,
    # list: [1,2,3,4],
    list: lc[(x,y) | (x <- countup(1,5), y<-1..3), (int,int)],
    width: dom.window.screen.width,
    height: dom.window.screen.height
}
# var b = jsnew(Vue)
var v = newVue(Option{
    el:"#id",
    data: model,
    methods: js{
        click: proc() =
            log("111")
            model.str = "==============="
            log("222")
    },
    asdf:123
})
# v.set(v, "a", 1.toJs)
v.watch("str", (n:cstring) => (log(n)))
log(v,"xxx")
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
