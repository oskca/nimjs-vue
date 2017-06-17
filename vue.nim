import dom, jsffi, times

type
    Instance* {.importc.} = ref object of js
        ## Vue Instance
        data* {.importc:"$$$1".} :js
        props* {.importc:"$$$1".} :js
        el* {.importc:"$$$1".} : dom.Element
        options* {.importc:"$$$1".} :js
        root* {.importc:"$$$1".} : Instance
        parent* {.importc:"$$$1".} : Instance
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

    Component* = ref object of Instance

    Option* = ref object of js
        ## VueJS Instance options
        el* : cstring
        data* : js
        methods* : js

        parent*: Instance
        ## Specify the parent Instance for the Instance to be created. Establishes a parent-child relationship between the two. The parent will be accessible as this.$parent for the child, and the child will be pushed into the parent’s $children array.

        delimiters*: array[2, cstring]
        ##  Change the plain text interpolation delimiters


        directives: js
        filters: js
        components: js

        mixins*: seq[js]
        ## The mixins option accepts an array of mixin objects. These mixin objects can contain Instance options just like normal Instance objects, and they will be merged against the eventual options using the same option merging logic in Vue.extend(). e.g. If your mixin contains a created hook and the component itself also has one, both functions will be called.

    ComponentOption* = ref object of js
        ## Components are custom elements that Vue’s compiler attaches behavior to. They help you extend basic HTML elements to encapsulate reusable code.
        name*: cstring
        ## only respected when used as a component option.

        tmpl* {.importc:"template".} : cstring
        ## tempalte to ceate the component

        data*: proc():js
        ## data must be function

        methods* : js
        ## methods bind to component

        props*: seq[cstring]
        ## A prop is a custom attribute for passing information from parent components. A child component needs to explicitly declare the props it expects to receive using the props option

        model*: js
        ## Allows a custom component to customize the prop and event used when it’s used with v-model. By default, v-model on a component uses value as the prop and input as the event, but some input types such as checkboxes and radio buttons may want to use the value prop for a different purpose. Using the model option can avoid the conflict in such cases.

        functional*: bool
        ## Causes a component to be stateless (no data) and Instanceless (no this context). They are simply a render function that returns virtual nodes making them much cheaper to render.


    DirectiveBinding* = ref object of js
        ## An object containing the following properties.
        name*: cstring
        ## name: The name of the directive, without the v- prefix.
        value*: js
        ## value: The value passed to the directive. For example in v-my-directive="1 + 1", the value would be 2.
        oldValue*: js
        ## oldValue: The previous value, only available in update and componentUpdated. It is available whether or not the value has changed.
        expression*: cstring
        ## expression: The expression of the binding as a string. For example in v-my-directive="1 + 1", the expression would be "1 + 1".
        arg*: cstring
        ## arg: The argument passed to the directive, if any. For example in v-my-directive:foo, the arg would be "foo".
        modifiers*: js
        ## modifiers: An object containing modifiers, if any. For example in v-my-directive.foo.bar, the modifiers object would be { foo: true, bar: true }.

proc newVue*(o: Option): Instance {.importcpp:"new Vue(#)"}
proc newVue*(): Instance {.importcpp:"new Vue()"} ## used for cross component comunication

proc newDirectiveRaw*(name: cstring): void {.importcpp:"Vue.directive(@)", varargs.}
proc newDirective*(name: cstring, updater: proc(el: dom.Element, b: DirectiveBinding)) =
    ## helper proc to create directives with only binder/updater
    newDirectiveRaw(name, updater)

proc newComponentRaw*(name: cstring): Component {.importcpp:"Vue.component(@)", varargs, discardable.}
proc newComponent*(name: cstring, o:ComponentOption): Component {.discardable.} =
    ## helper function to easy component creation
    newComponentRaw(name, o)

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

{.push importc:"Vue.$1".}
proc extend*(o: Option): Instance
proc nextTick*(fn:any): void
proc set*(target: any, key:cstring, value: any): void
proc delete*(target: any, key:cstring): void
proc filter*(name: cstring) {.varargs.}
proc use*(plugin: js): void
proc compile*(tmpl: cstring): void
{.pop.}

proc mix*(mix: js): void {.importc:"Vue.mixin(@)".}
