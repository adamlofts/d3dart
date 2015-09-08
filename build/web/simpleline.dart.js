(function(){var supportsDirectProtoAccess=function(){var z=function(){}
z.prototype={p:{}}
var y=new z()
return y.__proto__&&y.__proto__.p===z.prototype.p}()
function map(a){a=Object.create(null)
a.x=0
delete a.x
return a}var A=map()
var B=map()
var C=map()
var D=map()
var E=map()
var F=map()
var G=map()
var H=map()
var J=map()
var K=map()
var L=map()
var M=map()
var N=map()
var O=map()
var P=map()
var Q=map()
var R=map()
var S=map()
var T=map()
var U=map()
var V=map()
var W=map()
var X=map()
var Y=map()
var Z=map()
function I(){}init()
function setupProgram(a,b){"use strict"
function generateAccessor(a9,b0,b1){var g=a9.split("-")
var f=g[0]
var e=f.length
var d=f.charCodeAt(e-1)
var c
if(g.length>1)c=true
else c=false
d=d>=60&&d<=64?d-59:d>=123&&d<=126?d-117:d>=37&&d<=43?d-27:0
if(d){var a0=d&3
var a1=d>>2
var a2=f=f.substring(0,e-1)
var a3=f.indexOf(":")
if(a3>0){a2=f.substring(0,a3)
f=f.substring(a3+1)}if(a0){var a4=a0&2?"r":""
var a5=a0&1?"this":"r"
var a6="return "+a5+"."+f
var a7=b1+".prototype.g"+a2+"="
var a8="function("+a4+"){"+a6+"}"
if(c)b0.push(a7+"$reflectable("+a8+");\n")
else b0.push(a7+a8+";\n")}if(a1){var a4=a1&2?"r,v":"v"
var a5=a1&1?"this":"r"
var a6=a5+"."+f+"=v"
var a7=b1+".prototype.s"+a2+"="
var a8="function("+a4+"){"+a6+"}"
if(c)b0.push(a7+"$reflectable("+a8+");\n")
else b0.push(a7+a8+";\n")}}return f}function defineClass(a1,a2){var g=[]
var f="function "+a1+"("
var e=""
for(var d=0;d<a2.length;d++){if(d!=0)f+=", "
var c=generateAccessor(a2[d],g,a1)
var a0="p_"+c
f+=a0
e+="this."+c+" = "+a0+";\n"}if(supportsDirectProtoAccess)e+="this."+"$deferredAction"+"();"
f+=") {\n"+e+"}\n"
f+=a1+".builtin$cls=\""+a1+"\";\n"
f+="$desc=$collectedClasses."+a1+"[1];\n"
f+=a1+".prototype = $desc;\n"
if(typeof defineClass.name!="string")f+=a1+".name=\""+a1+"\";\n"
f+=g.join("")
return f}var z=supportsDirectProtoAccess?function(c,d){var g=c.prototype
g.__proto__=d.prototype
g.constructor=c
g["$is"+c.name]=c
return convertToFastObject(g)}:function(){function tmp(){}return function(a0,a1){tmp.prototype=a1.prototype
var g=new tmp()
convertToSlowObject(g)
var f=a0.prototype
var e=Object.keys(f)
for(var d=0;d<e.length;d++){var c=e[d]
g[c]=f[c]}g["$is"+a0.name]=a0
g.constructor=a0
a0.prototype=g
return g}}()
function finishClasses(a4){var g=init.allClasses
a4.combinedConstructorFunction+="return [\n"+a4.constructorsList.join(",\n  ")+"\n]"
var f=new Function("$collectedClasses",a4.combinedConstructorFunction)(a4.collected)
a4.combinedConstructorFunction=null
for(var e=0;e<f.length;e++){var d=f[e]
var c=d.name
var a0=a4.collected[c]
var a1=a0[0]
a0=a0[1]
g[c]=d
a1[c]=d}f=null
var a2=init.finishedClasses
function finishClass(c1){if(a2[c1])return
a2[c1]=true
var a5=a4.pending[c1]
if(a5&&a5.indexOf("+")>0){var a6=a5.split("+")
a5=a6[0]
var a7=a6[1]
finishClass(a7)
var a8=g[a7]
var a9=a8.prototype
var b0=g[c1].prototype
var b1=Object.keys(a9)
for(var b2=0;b2<b1.length;b2++){var b3=b1[b2]
if(!u.call(b0,b3))b0[b3]=a9[b3]}}if(!a5||typeof a5!="string"){var b4=g[c1]
var b5=b4.prototype
b5.constructor=b4
b5.$isa=b4
b5.$deferredAction=function(){}
return}finishClass(a5)
var b6=g[a5]
if(!b6)b6=existingIsolateProperties[a5]
var b4=g[c1]
var b5=z(b4,b6)
if(a9)b5.$deferredAction=mixinDeferredActionHelper(a9,b5)
if(Object.prototype.hasOwnProperty.call(b5,"%")){var b7=b5["%"].split(";")
if(b7[0]){var b8=b7[0].split("|")
for(var b2=0;b2<b8.length;b2++){init.interceptorsByTag[b8[b2]]=b4
init.leafTags[b8[b2]]=true}}if(b7[1]){b8=b7[1].split("|")
if(b7[2]){var b9=b7[2].split("|")
for(var b2=0;b2<b9.length;b2++){var c0=g[b9[b2]]
c0.$nativeSuperclassTag=b8[0]}}for(b2=0;b2<b8.length;b2++){init.interceptorsByTag[b8[b2]]=b4
init.leafTags[b8[b2]]=false}}b5.$deferredAction()}if(b5.$isGv)b5.$deferredAction()}var a3=Object.keys(a4.pending)
for(var e=0;e<a3.length;e++)finishClass(a3[e])}function finishAddStubsHelper(){var g=this
while(!g.hasOwnProperty("$deferredAction"))g=g.__proto__
delete g.$deferredAction
var f=Object.keys(g)
for(var e=0;e<f.length;e++){var d=f[e]
var c=d.charCodeAt(0)
var a0
if(d!=="^"&&d!=="$reflectable"&&c!==43&&c!==42&&(a0=g[d])!=null&&a0.constructor===Array&&d!=="<>")addStubs(g,a0,d,false,[])}convertToFastObject(g)
g=g.__proto__
g.$deferredAction()}function mixinDeferredActionHelper(c,d){var g
if(d.hasOwnProperty("$deferredAction"))g=d.$deferredAction
return function foo(){var f=this
while(!f.hasOwnProperty("$deferredAction"))f=f.__proto__
if(g)f.$deferredAction=g
else{delete f.$deferredAction
convertToFastObject(f)}c.$deferredAction()
f.$deferredAction()}}function processClassData(b1,b2,b3){b2=convertToSlowObject(b2)
var g
var f=Object.keys(b2)
var e=false
var d=supportsDirectProtoAccess&&b1!="a"
for(var c=0;c<f.length;c++){var a0=f[c]
var a1=a0.charCodeAt(0)
if(a0==="static"){processStatics(init.statics[b1]=b2.static,b3)
delete b2.static}else if(a1===43){w[g]=a0.substring(1)
var a2=b2[a0]
if(a2>0)b2[g].$reflectable=a2}else if(a1===42){b2[g].$defaultValues=b2[a0]
var a3=b2.$methodsWithOptionalArguments
if(!a3)b2.$methodsWithOptionalArguments=a3={}
a3[a0]=g}else{var a4=b2[a0]
if(a0!=="^"&&a4!=null&&a4.constructor===Array&&a0!=="<>")if(d)e=true
else addStubs(b2,a4,a0,false,[])
else g=a0}}if(e)b2.$deferredAction=finishAddStubsHelper
var a5=b2["^"],a6,a7,a8=a5
var a9=a8.split(";")
a8=a9[1]==""?[]:a9[1].split(",")
a7=a9[0]
a6=a7.split(":")
if(a6.length==2){a7=a6[0]
var b0=a6[1]
if(b0)b2.$signature=function(b4){return function(){return init.types[b4]}}(b0)}if(a7)b3.pending[b1]=a7
b3.combinedConstructorFunction+=defineClass(b1,a8)
b3.constructorsList.push(b1)
b3.collected[b1]=[m,b2]
i.push(b1)}function processStatics(a3,a4){var g=Object.keys(a3)
for(var f=0;f<g.length;f++){var e=g[f]
if(e==="^")continue
var d=a3[e]
var c=e.charCodeAt(0)
var a0
if(c===43){v[a0]=e.substring(1)
var a1=a3[e]
if(a1>0)a3[a0].$reflectable=a1
if(d&&d.length)init.typeInformation[a0]=d}else if(c===42){m[a0].$defaultValues=d
var a2=a3.$methodsWithOptionalArguments
if(!a2)a3.$methodsWithOptionalArguments=a2={}
a2[e]=a0}else if(typeof d==="function"){m[a0=e]=d
h.push(e)
init.globalFunctions[e]=d}else if(d.constructor===Array)addStubs(m,d,e,true,h)
else{a0=e
processClassData(e,d,a4)}}}function addStubs(b2,b3,b4,b5,b6){var g=0,f=b3[g],e
if(typeof f=="string")e=b3[++g]
else{e=f
f=b4}var d=[b2[b4]=b2[f]=e]
e.$stubName=b4
b6.push(b4)
for(g++;g<b3.length;g++){e=b3[g]
if(typeof e!="function")break
if(!b5)e.$stubName=b3[++g]
d.push(e)
if(e.$stubName){b2[e.$stubName]=e
b6.push(e.$stubName)}}for(var c=0;c<d.length;g++,c++)d[c].$callName=b3[g]
var a0=b3[g]
b3=b3.slice(++g)
var a1=b3[0]
var a2=a1>>1
var a3=(a1&1)===1
var a4=a1===3
var a5=a1===1
var a6=b3[1]
var a7=a6>>1
var a8=(a6&1)===1
var a9=a2+a7!=d[0].length
var b0=b3[2]
if(typeof b0=="number")b3[2]=b0+b
var b1=2*a7+a2+3
if(a0){e=tearOff(d,b3,b5,b4,a9)
b2[b4].$getter=e
e.$getterStub=true
if(b5){init.globalFunctions[b4]=e
b6.push(a0)}b2[a0]=e
d.push(e)
e.$stubName=a0
e.$callName=null}}function tearOffGetter(c,d,e,f){return f?new Function("funcs","reflectionInfo","name","H","c","return function tearOff_"+e+y+++"(x) {"+"if (c === null) c = H.qm("+"this, funcs, reflectionInfo, false, [x], name);"+"return new c(this, funcs[0], x, name);"+"}")(c,d,e,H,null):new Function("funcs","reflectionInfo","name","H","c","return function tearOff_"+e+y+++"() {"+"if (c === null) c = H.qm("+"this, funcs, reflectionInfo, false, [], name);"+"return new c(this, funcs[0], null, name);"+"}")(c,d,e,H,null)}function tearOff(c,d,e,f,a0){var g
return e?function(){if(g===void 0)g=H.qm(this,c,d,true,[],f).prototype
return g}:tearOffGetter(c,d,f,a0)}var y=0
if(!init.libraries)init.libraries=[]
if(!init.mangledNames)init.mangledNames=map()
if(!init.mangledGlobalNames)init.mangledGlobalNames=map()
if(!init.statics)init.statics=map()
if(!init.typeInformation)init.typeInformation=map()
if(!init.globalFunctions)init.globalFunctions=map()
var x=init.libraries
var w=init.mangledNames
var v=init.mangledGlobalNames
var u=Object.prototype.hasOwnProperty
var t=a.length
var s=map()
s.collected=map()
s.pending=map()
s.constructorsList=[]
s.combinedConstructorFunction="function $reflectable(fn){fn.$reflectable=1;return fn};\n"+"var $desc;\n"
for(var r=0;r<t;r++){var q=a[r]
var p=q[0]
var o=q[1]
var n=q[2]
var m=q[3]
var l=q[4]
var k=!!q[5]
var j=l&&l["^"]
if(j instanceof Array)j=j[0]
var i=[]
var h=[]
processStatics(l,s)
x.push([p,o,i,h,n,j,k,m])}finishClasses(s)}Cq=function(){}
var dart=[["","",,F,{
"^":"",
Y:function(a){var z,y
z=F.bj(null)
if(a!=null){y=z.gv(z)
z.sv(0,y+1)
z.q(0,y,a)}return new F.Hv(null,[z])},
rV:function(a,b,c){var z,y
z=H.J([],[P.FK])
y=b
while(!0){if(typeof y!=="number")return y.w()
if(typeof a!=="number")return H.o(a)
if(!(y<a))break
z.push(y)
if(typeof c!=="number")return H.o(c)
y+=c}return z},
xH:function(a,b){var z,y,x,w,v,u,t
z=J.U6(a)
y=z.gv(a)
x=-1
w=null
while(!0){++x
if(typeof y!=="number")return H.o(y)
if(x<y){w=b.$2(z.p(a,x),x)
if(w!=null){if(typeof w!=="number")return w.B()
v=w<=w}else v=!1
v=!v
u=w}else{u=null
v=!1}if(!v)break}for(;++x,x<y;){t=b.$2(z.p(a,x),x)
if(t!=null){if(typeof u!=="number")return u.A()
if(typeof t!=="number")return H.o(t)
if(u>t)u=t
if(typeof w!=="number")return w.w()
if(w<t)w=t}}return[u,w]},
Zp:[function(a,b){var z={}
z.Q=b
if(typeof b!=="number")return b.T()
if(typeof a!=="number")return H.o(a)
z.Q=b-a
return new F.x2(z,a)},"$2","N",4,0,1],
MQ:[function(a,b){var z,y
z={}
z.Q=b
if(typeof b!=="number")return b.T()
if(typeof a!=="number")return H.o(a)
y=b-a
z.Q=y!==0?1/y:0
return new F.uv(z,a)},"$2","Wt",4,0,1],
IR:[function(a,b,c,d){var z,y,x
z=a.length
if(0>=z)return H.e(a,0)
y=a[0]
if(1>=z)return H.e(a,1)
x=c.$2(y,a[1])
y=b.length
if(0>=y)return H.e(b,0)
z=b[0]
if(1>=y)return H.e(b,1)
return new F.Rk(x,d.$2(z,b[1]))},"$4","pw",8,0,2],
nu:function(a){var z,y,x,w
z=J.Tf(a,0)
y=a.length
x=y-1
if(x<0)return H.e(a,x)
w=a[x]
if(typeof z!=="number")return z.w()
if(typeof w!=="number")return H.o(w)
if(z<w)return[z,w]
return[w,z]},
va:function(a){if(a instanceof F.G3)return F.nu(a.a)
return F.nu(a.gcc())},
j4:{
"^":"lD;KV:Q>,a",
p:function(a,b){var z=this.a
if(b>>>0!==b||b>=z.length)return H.e(z,b)
return z[b]},
q:function(a,b,c){var z=this.a
if(b<0||b>=z.length)return H.e(z,b)
z[b]=c},
gv:function(a){return this.a.length},
sv:function(a,b){C.Nm.sv(this.a,b)},
M2:function(a){var z
if(a!=null){if(typeof a!=="number")return H.o(a)
z=Array(a)
z.fixed$length=Array
this.a=H.J(z,[W.cv])}else this.a=[]},
$iszM:1,
$aszM:function(){return[W.cv]},
$aslD:function(){return[W.cv]},
static:{bj:function(a){var z=new F.j4(null,null)
z.M2(a)
return z}}},
Hv:{
"^":"a;Q,a",
gv:function(a){return this.a.length},
sa4:function(a,b){this.smW(new F.Go(b))},
smW:function(a){this.en(new F.KY(a))},
gO:function(a){return new F.X(this)},
xe:function(a,b){this.c3(a,new F.Ah(b))},
c3:function(a,b){this.en(new F.av(a,b))},
Nm:function(a,b){return this.zP(new F.Lt(b))},
zP:function(a){var z={}
z.Q=0
return new F.Hv(null,H.J(new H.A8(this.a,new F.pY(z,a)),[null,null]).br(0))},
xE:function(a){var z,y,x,w,v,u,t,s,r
z=[]
for(y=this.a,x=y.length,w=0,v=0;v<y.length;y.length===x||(0,H.lk)(y),++v){for(u=J.Nx(y[v]),t=0;u.D();){s=u.gk()
if(s!=null){r=new F.j4(null,null)
r.a=[]
r.Q=s
r.Ay(r,J.MK(s,a))
z.push(r)}++t}++w}return new F.Hv(null,z)},
nv:function(a,b,c){var z,y,x,w,v,u,t,s,r,q,p,o,n
z=J.U6(a)
y=z.gv(a)
x=b.length
w=P.C(y,x)
v=new F.j4(null,null)
u=Array(x)
u.fixed$length=Array
u.$builtinTypeInfo=[W.cv]
v.a=u
t=new F.j4(null,null)
u=Array(x)
u.fixed$length=Array
u.$builtinTypeInfo=[W.cv]
t.a=u
s=new F.j4(null,null)
if(y!=null){if(typeof y!=="number")return H.o(y)
u=Array(y)
u.fixed$length=Array
u.$builtinTypeInfo=[W.cv]
s.a=u}else s.a=[]
v.Q=z.gKV(a)
t.Q=z.gKV(a)
s.Q=z.gKV(a)
for(r=0;r<w;++r){q=z.p(a,r)
if(r>=b.length)return H.e(b,r)
p=b[r]
if(q!=null){$.Ai().q(0,q,p)
u=t.a
if(r>=u.length)return H.e(u,r)
u[r]=q}else{o=document.createElement("span",null)
$.Ai().q(0,o,p)
u=v.a
if(r>=u.length)return H.e(u,r)
u[r]=o}}for(;r<x;++r){if(r>=b.length)return H.e(b,r)
u=b[r]
o=document.createElement("span",null)
$.Ai().q(0,o,u)
u=v.a
if(r>=u.length)return H.e(u,r)
u[r]=o}if(typeof y!=="number")return H.o(y)
for(;r<y;++r){u=z.p(a,r)
n=s.a
if(r>=n.length)return H.e(n,r)
n[r]=u}return[v,t,s]},
Db:function(a,b,c){var z,y,x,w,v,u,t
z=[]
y=[]
x=[]
for(w=this.a,v=w.length,u=0;u<w.length;w.length===v||(0,H.lk)(w),++u){t=this.nv(w[u],b,c)
z.push(t[0])
y.push(t[1])
x.push(t[2])}return new F.Q5(z,x,this,y)},
ob:function(a,b){return this.Db(a,b,null)},
sD5:function(a){this.en(new F.kG(a))},
en:function(a){var z,y,x,w,v,u,t,s,r
for(z=this.a,y=z.length,x=0,w=0;w<z.length;z.length===y||(0,H.lk)(z),++w){for(v=J.Nx(z[w]),u=0;v.D();){t=v.gk()
if(t!=null){s=$.Ai()
s.toString
r=H.VK(t,"expando$values")
a.$4(t,r==null?null:H.VK(r,s.Ux()),u,x)}++u}++x}},
Y:function(a,b){return this.zP(new F.cX(b,$.Hn().tg(0,b)))},
$1:function(a){a.$1(this)},
static:{wW:function(a){return a.zP(new F.ln())}}},
ln:{
"^":"r;",
$4:function(a,b,c,d){return a},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
Go:{
"^":"r;Q",
$2:function(a,b){return this.Q}},
KY:{
"^":"r;Q",
$4:function(a,b,c,d){J.t3(a,this.Q.$2(b,c))},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
Ah:{
"^":"r;Q",
$2:function(a,b){return J.Lz(this.Q)}},
av:{
"^":"r;Q,a",
$4:function(a,b,c,d){J.Vs(a).Q.setAttribute(this.Q,J.Lz(this.a.$2(b,c)))},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
Lt:{
"^":"r;Q",
$4:function(a,b,c,d){return J.c1(a,this.Q)},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
pY:{
"^":"r;Q,a",
$1:function(a){var z,y,x,w,v,u,t,s,r
z=F.bj(null)
y=J.R(a)
z.Q=y.gKV(a)
for(y=y.gu(a),x=this.Q,w=this.a,v=0;y.D();){u=y.c
if(u!=null){t=$.Ai()
t.toString
s=H.VK(u,"expando$values")
t=s==null?null:H.VK(s,t.Ux())
r=w.$4(u,t,v,x.Q)
if(r!=null){t=$.Ai()
t.toString
s=H.VK(u,"expando$values")
t.q(0,r,s==null?null:H.VK(s,t.Ux()))}}else r=null
t=z.gv(z)
z.sv(0,t+1)
z.q(0,t,r);++v}++x.Q
return z}},
kG:{
"^":"r;Q",
$4:function(a,b,c,d){$.Ai().q(0,a,this.Q)},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
cX:{
"^":"r;Q,a",
$4:function(a,b,c,d){var z,y
z=this.Q
y=this.a?W.r3(z,null):document.createElementNS("http://www.w3.org/2000/svg",z)
J.RG(a,y)
return y},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
Q5:{
"^":"Hv;b,c,Q,a"},
fu:{
"^":"Hv;Q,a",
zP:function(a){var z={}
z.Q=0
return new F.Hv(null,H.J(new H.A8(this.a,new F.O8(z,a)),[null,null]).br(0))}},
O8:{
"^":"r;Q,a",
$1:function(a){var z,y,x,w,v,u,t,s,r,q,p
z=F.bj(null)
y=J.R(a)
z.Q=y.gKV(a)
for(x=y.gu(a),w=this.Q,v=this.a,u=0;x.D();){t=x.c
if(t!=null){s=a.Q
r=$.Ai()
r.toString
q=H.VK(t,"expando$values")
r=q==null?null:H.VK(q,r.Ux())
p=v.$4(s,r,u,w.Q)
y.q(a,u,p)
if(p!=null){s=$.Ai()
s.toString
q=H.VK(t,"expando$values")
s.q(0,p,q==null?null:H.VK(q,s.Ux()))}}else p=null
s=z.gv(z)
z.sv(0,s+1)
z.q(0,s,p);++u}++w.Q
return z}},
X:{
"^":"a;Q",
MW:function(a,b,c){this.Q.en(new F.aR(b,c))},
spj:function(a){this.MW(0,"text-anchor",new F.Rj(a))},
sxJ:function(a){this.MW(0,"width",new F.jJ(a))}},
aR:{
"^":"r;Q,a",
$4:function(a,b,c,d){var z=this.a.$2(b,c)
J.vA(J.EJ(a),this.Q,z)},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
Rj:{
"^":"r;Q",
$2:function(a,b){return this.Q}},
jJ:{
"^":"r;Q",
$2:function(a,b){return this.Q}},
kn:{
"^":"a;",
xp:function(a,b){var z,y,x
z=b.Y(0,"g")
z.xe("class","ygridlines")
y=z.xE(".gridline").ob(0,a.KD(a.Q,10))
x=new F.fu(y,y.b).Y(0,"g")
x.xe("class","gridline")
x.Y(0,"line")
x.c3("transform",new F.qT(a))
x.Nm(0,"line").xe("x2",this.Q)},
Zq:function(a,b,c){var z,y,x,w,v
if(this.b){z=F.Y(a).Y(0,"div")
z.xe("class","legend")
y=this.e.p(0,"right")
if(typeof y!=="number")return y.T()
new F.X(z).sxJ(""+(y-5)+"px")
x=z.xE(".legend-item").ob(0,b)
w=new F.fu(x,x.b).Y(0,"div")
w.xe("class","legend-item clearfix")
v=w.Y(0,"div")
v.xe("class","legend-key")
new F.X(v).MW(0,"background-color",new F.Nv(c))
w.Y(0,"div").smW(new F.BM())}}},
qT:{
"^":"r;Q",
$2:function(a,b){return"translate(0, "+H.d(this.Q.$1(a))+")"}},
Nv:{
"^":"r;Q",
$2:function(a,b){return"#"+J.Gw(this.Q.$1(J.Tf(J.n9(a),"y")),16)}},
BM:{
"^":"r;",
$2:function(a,b){return J.Lz(J.Tf(J.n9(a),"y"))}},
M:{
"^":"kn;r,x,y,z,ch,Q,a,b,c,d,e,f",
am:function(){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g
z=this.z
y=this.e.p(0,"left")
if(typeof z!=="number")return z.T()
if(typeof y!=="number")return H.o(y)
x=this.e.p(0,"right")
if(typeof x!=="number")return H.o(x)
this.Q=z-y-x
x=this.ch
y=this.e.p(0,"top")
if(typeof x!=="number")return x.T()
if(typeof y!=="number")return H.o(y)
z=this.e.p(0,"bottom")
if(typeof z!=="number")return H.o(z)
this.a=x-y-z
w=new F.G3([],null,null,null,P.V())
w.a=null
w.Z([0,this.Q],0.1)
v=new F.ps([0,1],[0,1],F.N(),!1,null,null)
v.Oi()
v.a=[this.a,0]
v.Oi()
z=this.r
u=F.Y(z).Y(0,"svg")
y=this.Q
x=this.e.p(0,"left")
if(typeof y!=="number")return y.g()
if(typeof x!=="number")return H.o(x)
t=this.e.p(0,"right")
if(typeof t!=="number")return H.o(t)
u.xe("width",y+x+t)
t=this.a
x=this.e.p(0,"top")
if(typeof t!=="number")return t.g()
if(typeof x!=="number")return H.o(x)
y=this.e.p(0,"bottom")
if(typeof y!=="number")return H.o(y)
u.xe("height",t+x+y)
s=u.Y(0,"g")
s.xe("transform","translate("+H.d(this.e.p(0,"left"))+","+H.d(this.e.p(0,"top"))+")")
w.sBr(0,H.J(new H.A8(this.y[0],new F.Tq()),[null,null]).br(0))
r=[0,0.000001]
for(y=this.y,y.length,q=0;q<2;++q){p=F.xH(y[q],new F.vc())
if(0>=r.length)return H.e(r,0)
x=P.C(r[0],p[0])
t=r.length
if(0>=t)return H.e(r,0)
r[0]=x
if(1>=t)return H.e(r,1)
t=P.u(r[1],p[1])
if(1>=r.length)return H.e(r,1)
r[1]=t}v.Q=r
v.Oi()
o=new F.L(null,"bottom",6,6,3,[10],null,null)
o.Q=w
o.a="bottom"
n=s.Y(0,"g")
n.xe("class","x axis")
n.xe("transform","translate(0,"+H.d(this.a)+")")
n.$1(o)
m=n.xE("text")
m.xe("transform","rotate(-65)")
new F.X(m).spj("end")
m.xe("dx","-1em")
m.xe("dy","0em")
this.xp(v,s)
l=new F.WP(null,null,F.B2(),new F.wJ(),null,0.7,new F.zO())
l.c=new F.z1()
l.Q=new F.zq(w)
l.a=new F.HU(v)
for(y=this.y,y.length,q=0;q<2;++q){k=y[q]
j=s.Y(0,"path")
j.xe("class","line")
j.sD5(k)
j.c3("stroke",new F.Bp(this))
j.c3("d",l)}i=new F.L(null,"bottom",6,6,3,[10],null,null)
i.Q=v
i.a="left"
i.r=this.f
h=s.Y(0,"g")
h.xe("class","y axis")
h.$1(i)
g=h.Y(0,"text")
g.xe("transform","rotate(-90)")
g.xe("y",6)
g.xe("dy",".71em")
new F.X(g).spj("end")
g.sa4(0,this.d)
this.Zq(z,this.y,this.x)},
Vp:function(a,b){return this.x.$1(b)}},
Tq:{
"^":"r;",
$1:function(a){return J.Tf(a,"x")}},
vc:{
"^":"r;",
$2:function(a,b){var z=J.Tf(a,"value")
return J.cE(z)||z==Infinity||z==-Infinity?0:z}},
z1:{
"^":"r;",
$2:function(a,b){var z=J.Tf(a,"value")
return!(J.cE(z)||z==Infinity||z==-Infinity)}},
zq:{
"^":"r;Q",
$2:function(a,b){return this.Q.$1(J.Tf(a,"x"))}},
HU:{
"^":"r;Q",
$2:function(a,b){return this.Q.$1(J.Tf(a,"value"))}},
Bp:{
"^":"r;Q",
$2:function(a,b){return"#"+J.Gw(this.Q.Vp(0,J.Tf(J.n9(a),"y")),16)}},
x2:{
"^":"r;Q,a",
$1:function(a){return J.WB(this.a,J.lX(this.Q.Q,a))}},
uv:{
"^":"r;Q,a",
$1:function(a){var z,y
z=this.a
if(typeof a!=="number")return a.T()
if(typeof z!=="number")return H.o(z)
y=this.Q.Q
if(typeof y!=="number")return H.o(y)
return(a-z)*y}},
Rk:{
"^":"r;Q,a",
$1:function(a){return this.a.$1(this.Q.$1(a))}},
ps:{
"^":"o9;Q,a,b,c,d,e",
$1:function(a){return this.YE(a)},
Oi:function(){this.e=F.pw().$4(this.Q,this.a,F.Wt(),this.b)
this.d=F.pw().$4(this.a,this.Q,F.Wt(),F.N())},
gcc:function(){return this.a},
gBr:function(a){return this.Q},
KD:function(a,b){var z,y,x,w,v,u,t
z=F.nu(a)
if(1>=z.length)return H.e(z,1)
y=z[1]
x=z[0]
if(typeof y!=="number")return y.T()
if(typeof x!=="number")return H.o(x)
w=y-x
x=C.CD.yu(Math.floor(Math.log(H.E0(w/b))/2.302585092994046))
H.E0(10)
H.E0(x)
v=Math.pow(10,x)
u=b/w*v
if(u<=0.15)v*=10
else if(u<=0.35)v*=5
else if(u<=0.75)v*=2
if(0>=z.length)return H.e(z,0)
y=z[0]
if(typeof y!=="number")return y.S()
y=C.CD.yu(Math.ceil(y/v))
x=z.length
if(0>=x)return H.e(z,0)
z[0]=y*v
if(1>=x)return H.e(z,1)
x=z[1]
if(typeof x!=="number")return x.S()
x=C.CD.yu(Math.floor(x/v))
if(1>=z.length)return H.e(z,1)
z[1]=x*v+v*0.5
z.push(v)
x=z.length
if(1>=x)return H.e(z,1)
y=z[1]
t=z[0]
if(2>=x)return H.e(z,2)
return F.rV(y,t,z[2])},
YE:function(a){return this.e.$1(a)}},
G3:{
"^":"o9;Q,a,b,c,d",
gcc:function(){return this.a},
scc:function(a){this.a=a
this.b=0
this.c=P.T(["t","range","a",[a]])},
gBr:function(a){return this.Q},
sBr:function(a,b){var z,y,x,w,v,u,t,s,r,q,p,o,n
this.Q=[]
this.d=P.V()
z=b.length
for(y=-1;++y,y<z;){x=this.d
if(y>=b.length)return H.e(b,y)
w=b[y]
if(!x.x4(w)){this.Q.push(w)
this.d.q(0,w,this.Q.length)}}if(this.c.p(0,"t")==="range"){x=this.c.p(0,"a")
if(0>=x.length)return H.e(x,0)
this.scc(x[0])}else{x=this.c.p(0,"t")
v=this.c
if(x==="rangePoints"){x=v.p(0,"a")
if(0>=x.length)return H.e(x,0)
x=x[0]
v=this.c.p(0,"a")
if(1>=v.length)return H.e(v,1)
this.Z(x,v[1])}else{x=v.p(0,"a")
if(0>=x.length)return H.e(x,0)
x=x[0]
v=this.c.p(0,"a")
if(1>=v.length)return H.e(v,1)
u=v[1]
v=this.c.p(0,"a")
if(2>=v.length)return H.e(v,2)
v=v[2]
t=J.Tf(x,1)
s=x.length
if(0>=s)return H.e(x,0)
r=x[0]
if(typeof t!=="number")return t.w()
if(typeof r!=="number")return H.o(r)
q=t<r
p=x[1]
if(q){if(1>=s)return H.e(x,1)
o=r}else{if(1>=s)return H.e(x,1)
o=p
p=r}if(typeof o!=="number")return o.T()
if(typeof p!=="number")return H.o(p)
t=o-p
s=this.Q.length
if(typeof u!=="number")return H.o(u)
if(typeof v!=="number")return H.o(v)
n=C.CD.yu(Math.floor(t/(s-u+2*v)))
t=this.IJ(p+C.ON.zQ((t-(this.Q.length-u)*n)/2),n)
this.a=t
if(q)this.a=C.Nm.gJS(t).br(0)
this.b=C.CD.zQ(n*(1-u))
this.c=P.T(["t","rangeRoundBands","a",[x,u,v]])}}},
$1:function(a){var z,y,x
z=this.d.p(0,a)
if(z==null){this.Q.push(a)
z=this.Q.length
this.d.q(0,a,z)}y=this.a
if(typeof z!=="number")return z.T()
x=C.jn.V(z-1,J.wS(y))
if(x<0||x>=y.length)return H.e(y,x)
return y[x]},
Z:function(a,b){var z,y,x,w
z=J.Tf(a,0)
if(1>=a.length)return H.e(a,1)
y=a[1]
if(typeof y!=="number")return y.T()
if(typeof z!=="number")return H.o(z)
x=P.u(1,this.Q.length-1)
if(typeof b!=="number")return H.o(b)
w=(y-z)/(x+b)
this.scc(this.IJ(this.Q.length<2?(z+y)/2:z+w*b/2,w))
this.b=0
this.c=P.T(["t","rangePoints","a",[a,b]])},
IJ:function(a,b){return H.J(new H.A8(F.rV(this.Q.length,0,1),new F.FL(a,b)),[null,null]).br(0)}},
FL:{
"^":"r;Q,a",
$1:function(a){if(typeof a!=="number")return H.o(a)
return J.WB(this.Q,this.a*a)}},
o9:{
"^":"a;"},
L:{
"^":"a;Q,a,b,c,d,e,f,r",
$1:function(a){a.en(new F.kB(this))},
Nc:[function(a,b){a.c3("transform",new F.bP(b))},"$2","gZ7",4,0,0],
HK:[function(a,b){a.c3("transform",new F.x4(b))},"$2","gcD",4,0,0]},
kB:{
"^":"r;Q",
$4:function(a,b,c,d){var z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
z=F.Y(a)
y=this.Q
x=y.Q
w=J.t(x)
if(!!w.$isps){H.m3(x,"$isps")
w=y.e[0]
v=x.KD(x.Q,w)}else v=w.gBr(x)
u=z.xE(".tick").ob(0,v)
t=new F.tJ()
s=new F.fu(u,u.b).Y(0,"g")
r=F.wW(u)
s.xe("class","tick")
q=F.va(x)
p=z.xE(".domain").ob(0,[0])
o=new F.fu(p,p.b).Y(0,"path")
o.xe("class","domain")
s.Y(0,"line")
s.Y(0,"text")
n=s.Nm(0,"line")
m=r.Nm(0,"line")
l=s.Nm(0,"text")
l.smW(t)
k=s.Nm(0,"text")
j=r.Nm(0,"text")
w=y.a
if(w==="bottom"){i=y.gZ7()
w=y.b
n.xe("y2",w)
h=y.d
k.xe("y",P.u(w,0)+h)
m.xe("x2",0)
m.xe("y2",w)
j.xe("x",0)
j.xe("y",P.u(w,0)+h)
l.xe("dy",".71em")
new F.X(l).spj("middle")
if(0>=q.length)return H.e(q,0)
y=y.c
h="M"+H.d(q[0])+","+y+"V0H"
if(1>=q.length)return H.e(q,1)
o.xe("d",h+H.d(q[1])+"V"+y)}else if(w==="top"){i=y.gZ7()
w=y.b
h=-w
n.xe("y2",h)
y=y.d
k.xe("y",-(P.u(w,0)+y))
m.xe("x2",0)
m.xe("y2",h)
j.xe("x",0)
j.xe("y",-(P.u(w,0)+y))
l.xe("dy","0em")
new F.X(l).spj("middle")}else{h=y.b
g=y.d
f=y.c
if(w==="left"){i=y.gcD()
y=-h
n.xe("x2",y)
k.xe("x",-(P.u(h,0)+g))
m.xe("x2",y)
m.xe("y2",0)
j.xe("x",-(P.u(h,0)+g))
j.xe("y",0)
l.xe("dy",".32em")
new F.X(l).spj("end")
f=-f
g="M"+f+","
if(0>=q.length)return H.e(q,0)
g=g+H.d(q[0])+"H0V"
if(1>=q.length)return H.e(q,1)
o.xe("d",g+H.d(q[1])+"H"+f)}else{i=y.gcD()
n.xe("x2",h)
k.xe("x",P.u(h,0)+g)
m.xe("x2",h)
m.xe("y2",0)
j.xe("x",P.u(h,0)+g)
j.xe("y",0)
l.xe("dy",".32em")
new F.X(l).spj("start")
y="M"+f+","
if(0>=q.length)return H.e(q,0)
y=y+H.d(q[0])+"H0V"
if(1>=q.length)return H.e(q,1)
o.xe("d",y+H.d(q[1])+"H"+f)}}if(x instanceof F.G3){y=x.b
if(typeof y!=="number")return y.S()
e=new F.Nw(x,y/2)
i.$2(s,e)
i.$2(r,e)}else{i.$2(s,x)
i.$2(r,x)}},
$3:function(a,b,c){return this.$4(a,b,c,null)}},
tJ:{
"^":"r;",
$2:function(a,b){return J.Lz(a)}},
Nw:{
"^":"r;Q,a",
$1:function(a){return J.WB(this.Q.$1(a),this.a)}},
bP:{
"^":"r;Q",
$2:function(a,b){return"translate("+H.d(this.Q.$1(a))+",0)"}},
x4:{
"^":"r;Q",
$2:function(a,b){return"translate(0, "+H.d(this.Q.$1(a))+")"}},
WP:{
"^":"a;Q,a,b,c,d,e,f",
$2:function(a,b){var z,y,x,w,v,u,t,s
z={}
y=[]
z.Q=[]
x=J.U6(a)
w=x.gv(a)
v=this.Q
u=this.a
t=new F.rH(z,this,y)
b=-1
while(!0){++b
if(typeof w!=="number")return H.o(w)
if(!(b<w))break
s=x.p(a,b)
if(this.kG(s,b)===!0)z.Q.push([v.$2(s,b),u.$2(s,b)])
else if(z.Q.length>0){t.$0()
z.Q=[]}}if(z.Q.length>0)t.$0()
return y.length>0?C.Nm.zV(y,""):null},
Q0:function(a,b){return this.b.$2(a,b)},
kG:function(a,b){return this.c.$2(a,b)},
zJ:function(a){return this.f.$1(a)},
static:{MJ:[function(a,b){return J.kl(a,new F.hS()).zV(0,"L")},"$2","B2",4,0,3]}},
wJ:{
"^":"r;",
$2:function(a,b){return!0}},
zO:{
"^":"r;",
$1:function(a){return a}},
rH:{
"^":"r;Q,a,b",
$0:function(){var z,y
z=this.b
z.push("M")
y=this.a
z.push(y.Q0(y.zJ(this.Q.Q),y.e))}},
hS:{
"^":"r;",
$1:function(a){var z=J.U6(a)
return H.d(z.p(a,0))+","+H.d(z.p(a,1))}}}],["","",,H,{
"^":"",
eo:{
"^":"a;Q"}}],["","",,J,{
"^":"",
t:function(a){return void 0},
Qu:function(a,b,c,d){return{i:a,p:b,e:c,x:d}},
ks:function(a){var z,y,x,w
z=a[init.dispatchPropertyName]
if(z==null)if($.Bv==null){H.XD()
z=a[init.dispatchPropertyName]}if(z!=null){y=z.p
if(!1===y)return z.i
if(!0===y)return a
x=Object.getPrototypeOf(a)
if(y===x)return z.i
if(z.e===x)throw H.b(new P.ds("Return interceptor for "+H.d(y(a,z))))}w=H.w3(a)
if(w==null){y=Object.getPrototypeOf(a)
if(y==null||y===Object.prototype)return C.ZQ
else return C.vB}return w},
Gv:{
"^":"a;",
m:function(a,b){return a===b},
giO:function(a){return H.wP(a)},
X:["VE",function(a){return H.H9(a)}],
"%":"ApplicationCacheErrorEvent|AutocompleteErrorEvent|ClipboardEvent|DOMError|ErrorEvent|Event|FileError|InputEvent|MediaError|MediaKeyError|Navigator|NavigatorUserMediaError|PositionError|SQLError|SVGAnimatedLength|SVGAnimatedLengthList|SVGAnimatedNumber|SpeechRecognitionError"},
yE:{
"^":"Gv;",
X:function(a){return String(a)},
giO:function(a){return a?519018:218159},
$isa2:1},
PE:{
"^":"Gv;",
m:function(a,b){return null==b},
X:function(a){return"null"},
giO:function(a){return 0}},
Ue:{
"^":"Gv;",
giO:function(a){return 0}},
iC:{
"^":"Ue;"},
kd:{
"^":"Ue;",
X:function(a){return String(a)}},
G:{
"^":"Gv;",
PP:function(a,b){if(!!a.fixed$length)throw H.b(new P.ub(b))},
aN:function(a,b){var z,y
z=a.length
for(y=0;y<z;++y){b.$1(a[y])
if(a.length!==z)throw H.b(new P.UV(a))}},
ez:function(a,b){return H.J(new H.A8(a,b),[null,null])},
zV:function(a,b){var z,y,x,w
z=a.length
y=Array(z)
y.fixed$length=Array
for(x=0;x<a.length;++x){w=H.d(a[x])
if(x>=z)return H.e(y,x)
y[x]=w}return y.join(b)},
Zv:function(a,b){if(b<0||b>=a.length)return H.e(a,b)
return a[b]},
gFV:function(a){if(a.length>0)return a[0]
throw H.b(H.Wp())},
gJS:function(a){return H.J(new H.iK(a),[H.Kp(a,0)])},
X:function(a){return P.WE(a,"[","]")},
gu:function(a){return new J.m1(a,a.length,0,null)},
giO:function(a){return H.wP(a)},
gv:function(a){return a.length},
sv:function(a,b){this.PP(a,"set length")
if(b<0)throw H.b(P.D(b,null,null))
a.length=b},
p:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.b(P.p(b))
if(b>=a.length||b<0)throw H.b(P.D(b,null,null))
return a[b]},
$iszM:1,
$aszM:null,
$isqC:1},
Po:{
"^":"G;"},
m1:{
"^":"a;Q,a,b,c",
gk:function(){return this.c},
D:function(){var z,y,x
z=this.Q
y=z.length
if(this.a!==y)throw H.b(new P.UV(z))
x=this.b
if(x>=y){this.c=null
return!1}this.c=z[x]
this.b=x+1
return!0}},
F:{
"^":"Gv;",
gOo:function(a){return a===0?1/a<0:a<0},
gG0:function(a){return isNaN(a)},
yu:function(a){var z
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){z=a<0?Math.ceil(a):Math.floor(a)
return z+0}throw H.b(new P.ub(""+a))},
zQ:function(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw H.b(new P.ub(""+a))},
WZ:function(a,b){var z,y,x,w
H.fI(b)
if(b<2||b>36)throw H.b(P.TE(b,2,36,"radix",null))
z=a.toString(b)
if(C.xB.O2(z,z.length-1)!==41)return z
y=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(z)
if(y==null)H.vh(new P.ub("Unexpected toString result: "+z))
x=J.U6(y)
z=x.p(y,1)
w=+x.p(y,3)
if(x.p(y,2)!=null){z+=x.p(y,2)
w-=x.p(y,2).length}return z+C.xB.R("0",w)},
X:function(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
giO:function(a){return a&0x1FFFFFFF},
g:function(a,b){if(typeof b!=="number")throw H.b(P.p(b))
return a+b},
R:function(a,b){if(typeof b!=="number")throw H.b(P.p(b))
return a*b},
V:function(a,b){var z=a%b
if(z===0)return 0
if(z>0)return z
if(b<0)return z-b
else return z+b},
$isFK:1},
im:{
"^":"F;",
$isCP:1,
$isFK:1,
$isKN:1},
VA:{
"^":"F;",
$isCP:1,
$isFK:1},
E:{
"^":"Gv;",
O2:function(a,b){if(b<0)throw H.b(P.D(b,null,null))
if(b>=a.length)throw H.b(P.D(b,null,null))
return a.charCodeAt(b)},
g:function(a,b){if(typeof b!=="string")throw H.b(P.p(b))
return a+b},
Nj:function(a,b,c){H.fI(b)
if(c==null)c=a.length
H.fI(c)
if(typeof c!=="number")return H.o(c)
if(b>c)throw H.b(P.D(b,null,null))
if(c>a.length)throw H.b(P.D(c,null,null))
return a.substring(b,c)},
yn:function(a,b){return this.Nj(a,b,null)},
R:function(a,b){var z,y
if(typeof b!=="number")return H.o(b)
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw H.b(C.Eq)
for(z=a,y="";!0;){if((b&1)===1)y=z+y
b=b>>>1
if(b===0)break
z+=z}return y},
Is:function(a,b,c){if(c>a.length)throw H.b(P.TE(c,0,a.length,null,null))
return H.m2(a,b,c)},
X:function(a){return a},
giO:function(a){var z,y,x
for(z=a.length,y=0,x=0;x<z;++x){y=536870911&y+a.charCodeAt(x)
y=536870911&y+((524287&y)<<10>>>0)
y^=y>>6}y=536870911&y+((67108863&y)<<3>>>0)
y^=y>>11
return 536870911&y+((16383&y)<<15>>>0)},
gv:function(a){return a.length},
p:function(a,b){if(typeof b!=="number"||Math.floor(b)!==b)throw H.b(P.p(b))
if(b>=a.length||b<0)throw H.b(P.D(b,null,null))
return a[b]},
$isI:1}}],["","",,H,{
"^":"",
Dm:function(a){return init.types[a]},
wV:function(a,b){var z
if(b!=null){z=b.x
if(z!=null)return z}return!!J.t(a).$isXj},
d:function(a){var z
if(typeof a==="string")return a
if(typeof a==="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
z=J.Lz(a)
if(typeof z!=="string")throw H.b(H.aL(a))
return z},
wP:function(a){var z=a.$identityHash
if(z==null){z=Math.random()*0x3fffffff|0
a.$identityHash=z}return z},
lh:function(a){var z,y
z=C.w2(J.t(a))
if(z==="Object"){y=String(a.constructor).match(/^\s*function\s*([\w$]*)\s*\(/)[1]
if(typeof y==="string")z=/^\w+$/.test(y)?y:z}if(z.length>1&&C.xB.O2(z,0)===36)z=C.xB.yn(z,1)
return(z+H.ia(H.oX(a),0,null)).replace(/[^<,> ]+/g,function(b){return init.mangledGlobalNames[b]||b})},
H9:function(a){return"Instance of '"+H.lh(a)+"'"},
VK:function(a,b){if(a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string")throw H.b(H.aL(a))
return a[b]},
aw:function(a,b,c){if(a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string")throw H.b(H.aL(a))
a[b]=c},
o:function(a){throw H.b(H.aL(a))},
e:function(a,b){if(a==null)J.wS(a)
if(typeof b!=="number"||Math.floor(b)!==b)H.o(b)
throw H.b(P.D(b,null,null))},
aL:function(a){return new P.AT(!0,a,null,null)},
E0:function(a){return a},
fI:function(a){if(typeof a!=="number"||Math.floor(a)!==a)throw H.b(H.aL(a))
return a},
b:function(a){var z
if(a==null)a=new P.LK()
z=new Error()
z.dartException=a
if("defineProperty" in Object){Object.defineProperty(z,"message",{get:H.Ju})
z.name=""}else z.toString=H.Ju
return z},
Ju:function(){return J.Lz(this.dartException)},
vh:function(a){throw H.b(a)},
lk:function(a){throw H.b(new P.UV(a))},
CU:function(a){if(a==null||typeof a!='object')return J.v1(a)
else return H.wP(a)},
B7:function(a,b){var z,y,x,w
z=a.length
for(y=0;y<z;y=w){x=y+1
w=x+1
b.q(0,a[y],a[x])}return b},
ft:function(a,b,c,d,e,f,g){var z=J.t(c)
if(z.m(c,0))return new H.dr(a).$0()
else if(z.m(c,1))return new H.TL(a,d).$0()
else if(z.m(c,2))return new H.KX(a,d,e).$0()
else if(z.m(c,3))return new H.uZ(a,d,e,f).$0()
else if(z.m(c,4))return new H.OQ(a,d,e,f,g).$0()
else throw H.b(new P.HG("Unsupported number of arguments for wrapped closure"))},
tR:function(a,b){var z
if(a==null)return
z=a.$identity
if(!!z)return z
z=function(c,d,e,f){return function(g,h,i,j){return f(c,e,d,g,h,i,j)}}(a,b,$,H.ft)
a.$identity=z
return z},
iA:function(a,b,c,d,e,f){var z,y,x,w,v,u,t,s,r,q,p,o,n,m
z=b[0]
y=z.$callName
if(!!J.t(c).$iszM){z.$reflectionInfo=c
x=H.zh(z).f}else x=c
w=d?Object.create(new H.zx().constructor.prototype):Object.create(new H.q(null,null,null,null).constructor.prototype)
w.$initialize=w.constructor
if(d)v=function(){this.$initialize()}
else{u=$.yj
$.yj=J.WB(u,1)
u=new Function("a,b,c,d","this.$initialize(a,b,c,d);"+u)
v=u}w.constructor=v
v.prototype=w
u=!d
if(u){t=e.length==1&&!0
s=H.bx(a,z,t)
s.$reflectionInfo=c}else{w.$name=f
s=z
t=!1}if(typeof x=="number")r=function(g){return function(){return H.Dm(g)}}(x)
else if(u&&typeof x=="function"){q=t?H.yS:H.DV
r=function(g,h){return function(){return g.apply({$receiver:h(this)},arguments)}}(x,q)}else throw H.b("Error in reflectionInfo.")
w.$signature=r
w[y]=s
for(u=b.length,p=1;p<u;++p){o=b[p]
n=o.$callName
if(n!=null){m=d?o:H.bx(a,o,t)
w[n]=m}}w["call*"]=s
w.$requiredArgCount=z.$requiredArgCount
w.$defaultValues=z.$defaultValues
return v},
vq:function(a,b,c,d){var z=H.DV
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,z)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,z)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,z)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,z)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,z)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,z)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,z)}},
bx:function(a,b,c){var z,y,x,w,v,u
if(c)return H.Hf(a,b)
z=b.$stubName
y=b.length
x=a[z]
w=b==null?x==null:b===x
v=!w||y>=27
if(v)return H.vq(y,!w,z,b)
if(y===0){w=$.mJ
if(w==null){w=H.E2("self")
$.mJ=w}w="return function(){return this."+H.d(w)+"."+H.d(z)+"();"
v=$.yj
$.yj=J.WB(v,1)
return new Function(w+H.d(v)+"}")()}u="abcdefghijklmnopqrstuvwxyz".split("").splice(0,y).join(",")
w="return function("+u+"){return this."
v=$.mJ
if(v==null){v=H.E2("self")
$.mJ=v}v=w+H.d(v)+"."+H.d(z)+"("+u+");"
w=$.yj
$.yj=J.WB(w,1)
return new Function(v+H.d(w)+"}")()},
Z4:function(a,b,c,d){var z,y
z=H.DV
y=H.yS
switch(b?-1:a){case 0:throw H.b(new H.tc("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,z,y)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,z,y)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,z,y)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,z,y)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,z,y)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,z,y)
default:return function(e,f,g,h){return function(){h=[g(this)]
Array.prototype.push.apply(h,arguments)
return e.apply(f(this),h)}}(d,z,y)}},
Hf:function(a,b){var z,y,x,w,v,u,t,s
z=H.oN()
y=$.P4
if(y==null){y=H.E2("receiver")
$.P4=y}x=b.$stubName
w=b.length
v=a[x]
u=b==null?v==null:b===v
t=!u||w>=28
if(t)return H.Z4(w,!u,x,b)
if(w===1){y="return function(){return this."+H.d(z)+"."+H.d(x)+"(this."+H.d(y)+");"
u=$.yj
$.yj=J.WB(u,1)
return new Function(y+H.d(u)+"}")()}s="abcdefghijklmnopqrstuvwxyz".split("").splice(0,w-1).join(",")
y="return function("+s+"){return this."+H.d(z)+"."+H.d(x)+"(this."+H.d(y)+", "+s+");"
u=$.yj
$.yj=J.WB(u,1)
return new Function(y+H.d(u)+"}")()},
qm:function(a,b,c,d,e,f){var z
b.fixed$length=Array
if(!!J.t(c).$iszM){c.fixed$length=Array
z=c}else z=c
return H.iA(a,b,z,!!d,e,f)},
aE:function(a,b){var z=J.U6(b)
throw H.b(H.aq(H.lh(a),z.Nj(b,3,z.gv(b))))},
m3:function(a,b){var z
if(a!=null)z=typeof a==="object"&&J.t(a)[b]
else z=!0
if(z)return a
H.aE(a,b)},
eQ:function(a){throw H.b(new P.t7("Cyclic initialization for static "+H.d(a)))},
J:function(a,b){if(a!=null)a.$builtinTypeInfo=b
return a},
oX:function(a){if(a==null)return
return a.$builtinTypeInfo},
IM:function(a,b){return H.Y9(a["$as"+H.d(b)],H.oX(a))},
W8:function(a,b,c){var z=H.IM(a,b)
return z==null?null:z[c]},
Kp:function(a,b){var z=H.oX(a)
return z==null?null:z[b]},
Ko:function(a,b){if(a==null)return"dynamic"
else if(typeof a==="object"&&a!==null&&a.constructor===Array)return a[0].builtin$cls+H.ia(a,1,b)
else if(typeof a=="function")return a.builtin$cls
else if(typeof a==="number"&&Math.floor(a)===a)return C.jn.X(a)
else return},
ia:function(a,b,c){var z,y,x,w,v,u
if(a==null)return""
z=new P.Rn("")
for(y=b,x=!0,w=!0,v="";y<a.length;++y){if(x)x=!1
else z.Q=v+", "
u=a[y]
if(u!=null)w=!1
v=z.Q+=H.d(H.Ko(u,c))}return w?"":"<"+H.d(z)+">"},
Y9:function(a,b){if(typeof a=="function"){a=H.ml(a,null,b)
if(a==null||typeof a==="object"&&a!==null&&a.constructor===Array)b=a
else if(typeof a=="function")b=H.ml(a,null,b)}return b},
ml:function(a,b,c){return a.apply(b,c)},
or:function(a){var z=$.NF
return"Instance of "+(z==null?"<Unknown>":z.$1(a))},
kE:function(a){return H.wP(a)},
iw:function(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
w3:function(a){var z,y,x,w,v,u
z=$.NF.$1(a)
y=$.nw[z]
if(y!=null){Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}x=$.vv[z]
if(x!=null)return x
w=init.interceptorsByTag[z]
if(w==null){z=$.TX.$2(a,z)
if(z!=null){y=$.nw[z]
if(y!=null){Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}x=$.vv[z]
if(x!=null)return x
w=init.interceptorsByTag[z]}}if(w==null)return
x=w.prototype
v=z[0]
if(v==="!"){y=H.Va(x)
$.nw[z]=y
Object.defineProperty(a,init.dispatchPropertyName,{value:y,enumerable:false,writable:true,configurable:true})
return y.i}if(v==="~"){$.vv[z]=x
return x}if(v==="-"){u=H.Va(x)
Object.defineProperty(Object.getPrototypeOf(a),init.dispatchPropertyName,{value:u,enumerable:false,writable:true,configurable:true})
return u.i}if(v==="+")return H.Lc(a,x)
if(v==="*")throw H.b(new P.ds(z))
if(init.leafTags[z]===true){u=H.Va(x)
Object.defineProperty(Object.getPrototypeOf(a),init.dispatchPropertyName,{value:u,enumerable:false,writable:true,configurable:true})
return u.i}else return H.Lc(a,x)},
Lc:function(a,b){var z=Object.getPrototypeOf(a)
Object.defineProperty(z,init.dispatchPropertyName,{value:J.Qu(b,z,null,null),enumerable:false,writable:true,configurable:true})
return b},
Va:function(a){return J.Qu(a,!1,null,!!a.$isXj)},
VF:function(a,b,c){var z=b.prototype
if(init.leafTags[a]===true)return J.Qu(z,!1,null,!!z.$isXj)
else return J.Qu(z,c,null,null)},
XD:function(){if(!0===$.Bv)return
$.Bv=!0
H.Z1()},
Z1:function(){var z,y,x,w,v,u,t,s
$.nw=Object.create(null)
$.vv=Object.create(null)
H.kO()
z=init.interceptorsByTag
y=Object.getOwnPropertyNames(z)
if(typeof window!="undefined"){window
x=function(){}
for(w=0;w<y.length;++w){v=y[w]
u=$.x7.$1(v)
if(u!=null){t=H.VF(v,z[v],u)
if(t!=null){Object.defineProperty(u,init.dispatchPropertyName,{value:t,enumerable:false,writable:true,configurable:true})
x.prototype=u}}}}for(w=0;w<y.length;++w){v=y[w]
if(/^[A-Za-z_]/.test(v)){s=z[v]
z["!"+v]=s
z["~"+v]=s
z["-"+v]=s
z["+"+v]=s
z["*"+v]=s}}},
kO:function(){var z,y,x,w,v,u,t
z=C.M1()
z=H.ud(C.Mc,H.ud(C.hQ,H.ud(C.XQ,H.ud(C.XQ,H.ud(C.Jh,H.ud(C.lR,H.ud(C.ur(C.w2),z)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){y=dartNativeDispatchHooksTransformer
if(typeof y=="function")y=[y]
if(y.constructor==Array)for(x=0;x<y.length;++x){w=y[x]
if(typeof w=="function")z=w(z)||z}}v=z.getTag
u=z.getUnknownTag
t=z.prototypeForTag
$.NF=new H.dC(v)
$.TX=new H.wN(u)
$.x7=new H.VX(t)},
ud:function(a,b){return a(b)||b},
m2:function(a,b,c){return a.indexOf(b,c)>=0},
FD:{
"^":"a;Q,a,b,c,d,e,f,r",
static:{zh:function(a){var z,y,x
z=a.$reflectionInfo
if(z==null)return
z.fixed$length=Array
z=z
y=z[0]
x=z[1]
return new H.FD(a,z,(y&1)===1,y>>1,x>>1,(x&1)===1,z[2],null)}}},
dr:{
"^":"r;Q",
$0:function(){return this.Q.$0()}},
TL:{
"^":"r;Q,a",
$0:function(){return this.Q.$1(this.a)}},
KX:{
"^":"r;Q,a,b",
$0:function(){return this.Q.$2(this.a,this.b)}},
uZ:{
"^":"r;Q,a,b,c",
$0:function(){return this.Q.$3(this.a,this.b,this.c)}},
OQ:{
"^":"r;Q,a,b,c,d",
$0:function(){return this.Q.$4(this.a,this.b,this.c,this.d)}},
r:{
"^":"a;",
X:function(a){return"Closure '"+H.lh(this)+"'"},
gKu:function(){return this},
gKu:function(){return this}},
lc:{
"^":"r;"},
zx:{
"^":"lc;",
X:function(a){var z=this.$name
if(z==null)return"Closure of unknown static method"
return"Closure '"+z+"'"}},
q:{
"^":"lc;Q,a,b,c",
m:function(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof H.q))return!1
return this.Q===b.Q&&this.a===b.a&&this.b===b.b},
giO:function(a){var z,y
z=this.b
if(z==null)y=H.wP(this.Q)
else y=typeof z!=="object"?J.v1(z):H.wP(z)
return(y^H.wP(this.a))>>>0},
X:function(a){var z=this.b
if(z==null)z=this.Q
return"Closure '"+H.d(this.c)+"' of "+H.H9(z)},
static:{DV:function(a){return a.Q},yS:function(a){return a.b},oN:function(){var z=$.mJ
if(z==null){z=H.E2("self")
$.mJ=z}return z},E2:function(a){var z,y,x,w,v
z=new H.q("self","target","receiver","name")
y=Object.getOwnPropertyNames(z)
y.fixed$length=Array
x=y
for(y=x.length,w=0;w<y;++w){v=x[w]
if(z[v]===a)return v}}}},
Pe:{
"^":"Ge;Q",
X:function(a){return this.Q},
static:{aq:function(a,b){return new H.Pe("CastError: Casting value of type "+a+" to incompatible type "+H.d(b))}}},
tc:{
"^":"Ge;Q",
X:function(a){return"RuntimeError: "+H.d(this.Q)}},
N5:{
"^":"a;Q,a,b,c,d,e,f",
gv:function(a){return this.Q},
x4:function(a){var z,y
if(typeof a==="string"){z=this.a
if(z==null)return!1
return this.Xu(z,a)}else if(typeof a==="number"&&(a&0x3ffffff)===a){y=this.b
if(y==null)return!1
return this.Xu(y,a)}else return this.CX(a)},
CX:function(a){var z=this.c
if(z==null)return!1
return this.Fh(this.r0(z,J.v1(a)&0x3ffffff),a)>=0},
p:function(a,b){var z,y,x
if(typeof b==="string"){z=this.a
if(z==null)return
y=this.r0(z,b)
return y==null?null:y.gLk()}else if(typeof b==="number"&&(b&0x3ffffff)===b){x=this.b
if(x==null)return
y=this.r0(x,b)
return y==null?null:y.gLk()}else return this.aa(b)},
aa:function(a){var z,y,x
z=this.c
if(z==null)return
y=this.r0(z,J.v1(a)&0x3ffffff)
x=this.Fh(y,a)
if(x<0)return
return y[x].gLk()},
q:function(a,b,c){var z,y,x,w,v,u
if(typeof b==="string"){z=this.a
if(z==null){z=this.zK()
this.a=z}this.ti(z,b,c)}else if(typeof b==="number"&&(b&0x3ffffff)===b){y=this.b
if(y==null){y=this.zK()
this.b=y}this.ti(y,b,c)}else{x=this.c
if(x==null){x=this.zK()
this.c=x}w=J.v1(b)&0x3ffffff
v=this.r0(x,w)
if(v==null)this.EI(x,w,[this.y4(b,c)])
else{u=this.Fh(v,b)
if(u>=0)v[u].sLk(c)
else v.push(this.y4(b,c))}}},
aN:function(a,b){var z,y
z=this.d
y=this.f
for(;z!=null;){b.$2(z.Q,z.a)
if(y!==this.f)throw H.b(new P.UV(this))
z=z.b}},
ti:function(a,b,c){var z=this.r0(a,b)
if(z==null)this.EI(a,b,this.y4(b,c))
else z.sLk(c)},
y4:function(a,b){var z,y
z=new H.db(a,b,null,null)
if(this.d==null){this.e=z
this.d=z}else{y=this.e
z.c=y
y.b=z
this.e=z}++this.Q
this.f=this.f+1&67108863
return z},
Fh:function(a,b){var z,y
if(a==null)return-1
z=a.length
for(y=0;y<z;++y)if(J.mG(a[y].gyK(),b))return y
return-1},
X:function(a){return P.vW(this)},
r0:function(a,b){return a[b]},
EI:function(a,b,c){a[b]=c},
rn:function(a,b){delete a[b]},
Xu:function(a,b){return this.r0(a,b)!=null},
zK:function(){var z=Object.create(null)
this.EI(z,"<non-identifier-key>",z)
this.rn(z,"<non-identifier-key>")
return z}},
db:{
"^":"a;yK:Q<,Lk:a@,b,c"},
dC:{
"^":"r;Q",
$1:function(a){return this.Q(a)}},
wN:{
"^":"r;Q",
$2:function(a,b){return this.Q(a,b)}},
VX:{
"^":"r;Q",
$1:function(a){return this.Q(a)}}}],["","",,H,{
"^":"",
Wp:function(){return new P.lj("No element")},
ho:{
"^":"Ly;",
gu:function(a){return new H.a7(this,this.gv(this),0,null)},
aN:function(a,b){var z,y
z=this.gv(this)
for(y=0;y<z;++y){b.$1(this.Zv(0,y))
if(z!==this.gv(this))throw H.b(new P.UV(this))}},
gFV:function(a){if(this.gv(this)===0)throw H.b(H.Wp())
return this.Zv(0,0)},
zV:function(a,b){var z,y,x,w,v
z=this.gv(this)
if(b.length!==0){if(z===0)return""
y=H.d(this.Zv(0,0))
if(z!==this.gv(this))throw H.b(new P.UV(this))
x=new P.Rn(y)
for(w=1;w<z;++w){x.Q+=b
x.Q+=H.d(this.Zv(0,w))
if(z!==this.gv(this))throw H.b(new P.UV(this))}v=x.Q
return v.charCodeAt(0)==0?v:v}else{x=new P.Rn("")
for(w=0;w<z;++w){x.Q+=H.d(this.Zv(0,w))
if(z!==this.gv(this))throw H.b(new P.UV(this))}v=x.Q
return v.charCodeAt(0)==0?v:v}},
ez:function(a,b){return H.J(new H.A8(this,b),[null,null])},
tt:function(a,b){var z,y,x
if(b){z=H.J([],[H.W8(this,"ho",0)])
C.Nm.sv(z,this.gv(this))}else{y=Array(this.gv(this))
y.fixed$length=Array
z=H.J(y,[H.W8(this,"ho",0)])}for(x=0;x<this.gv(this);++x){y=this.Zv(0,x)
if(x>=z.length)return H.e(z,x)
z[x]=y}return z},
br:function(a){return this.tt(a,!0)},
$isqC:1},
a7:{
"^":"a;Q,a,b,c",
gk:function(){return this.c},
D:function(){var z,y,x,w
z=this.Q
y=J.U6(z)
x=y.gv(z)
if(this.a!==x)throw H.b(new P.UV(z))
w=this.b
if(w>=x){this.c=null
return!1}this.c=y.Zv(z,w);++this.b
return!0}},
i1:{
"^":"Ly;Q,a",
gu:function(a){var z=new H.MH(null,J.Nx(this.Q),this.a)
z.$builtinTypeInfo=this.$builtinTypeInfo
return z},
gv:function(a){return J.wS(this.Q)},
gFV:function(a){return this.Mi(J.n9(this.Q))},
Mi:function(a){return this.a.$1(a)},
$asLy:function(a,b){return[b]},
static:{K1:function(a,b,c,d){if(!!a.$isqC)return H.J(new H.xy(a,b),[c,d])
return H.J(new H.i1(a,b),[c,d])}}},
xy:{
"^":"i1;Q,a",
$isqC:1},
MH:{
"^":"An;Q,a,b",
D:function(){var z=this.a
if(z.D()){this.Q=this.Mi(z.gk())
return!0}this.Q=null
return!1},
gk:function(){return this.Q},
Mi:function(a){return this.b.$1(a)}},
A8:{
"^":"ho;Q,a",
gv:function(a){return J.wS(this.Q)},
Zv:function(a,b){return this.Mi(J.i4(this.Q,b))},
Mi:function(a){return this.a.$1(a)},
$asho:function(a,b){return[b]},
$asLy:function(a,b){return[b]},
$isqC:1},
iK:{
"^":"ho;Q",
gv:function(a){return J.wS(this.Q)},
Zv:function(a,b){var z,y
z=this.Q
y=J.U6(z)
return y.Zv(z,y.gv(z)-1-b)}}}],["","",,P,{
"^":"",
V:function(){return H.J(new H.N5(0,null,null,null,null,null,0),[null,null])},
T:function(a){return H.B7(a,H.J(new H.N5(0,null,null,null,null,null,0),[null,null]))},
Ou:[function(a,b){return J.mG(a,b)},"$2","iv",4,0,4],
T9:[function(a){return J.v1(a)},"$1","rm",2,0,5],
EP:function(a,b,c){var z,y
if(P.hB(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}z=[]
y=$.xb()
y.push(a)
try{P.Vr(a,z)}finally{if(0>=y.length)return H.e(y,0)
y.pop()}y=P.vg(b,z,", ")+c
return y.charCodeAt(0)==0?y:y},
WE:function(a,b,c){var z,y,x
if(P.hB(a))return b+"..."+c
z=new P.Rn(b)
y=$.xb()
y.push(a)
try{x=z
x.Q=P.vg(x.gIN(),a,", ")}finally{if(0>=y.length)return H.e(y,0)
y.pop()}y=z
y.Q=y.gIN()+c
y=z.gIN()
return y.charCodeAt(0)==0?y:y},
hB:function(a){var z,y
for(z=0;y=$.xb(),z<y.length;++z)if(a===y[z])return!0
return!1},
Vr:function(a,b){var z,y,x,w,v,u,t,s,r,q
z=a.gu(a)
y=0
x=0
while(!0){if(!(y<80||x<3))break
if(!z.D())return
w=H.d(z.gk())
b.push(w)
y+=w.length+2;++x}if(!z.D()){if(x<=5)return
if(0>=b.length)return H.e(b,0)
v=b.pop()
if(0>=b.length)return H.e(b,0)
u=b.pop()}else{t=z.gk();++x
if(!z.D()){if(x<=4){b.push(H.d(t))
return}v=H.d(t)
if(0>=b.length)return H.e(b,0)
u=b.pop()
y+=v.length+2}else{s=z.gk();++x
for(;z.D();t=s,s=r){r=z.gk();++x
if(x>100){while(!0){if(!(y>75&&x>3))break
if(0>=b.length)return H.e(b,0)
y-=b.pop().length+2;--x}b.push("...")
return}}u=H.d(t)
v=H.d(s)
y+=v.length+u.length+4}}if(x>b.length+2){y+=5
q="..."}else q=null
while(!0){if(!(y>80&&b.length>3))break
if(0>=b.length)return H.e(b,0)
y-=b.pop().length+2
if(q==null){y+=5
q="..."}}if(q!=null)b.push(q)
b.push(u)
b.push(v)},
Ls:function(a,b,c,d){return H.J(new P.b6(0,null,null,null,null,null,0),[d])},
tM:function(a,b){var z,y
z=P.Ls(null,null,null,b)
for(y=0;y<1;++y)z.h(0,a[y])
return z},
vW:function(a){var z,y,x
z={}
if(P.hB(a))return"{...}"
y=new P.Rn("")
try{$.xb().push(a)
x=y
x.Q=x.gIN()+"{"
z.Q=!0
J.kH(a,new P.W0(z,y))
z=y
z.Q=z.gIN()+"}"}finally{z=$.xb()
if(0>=z.length)return H.e(z,0)
z.pop()}z=y.gIN()
return z.charCodeAt(0)==0?z:z},
b6:{
"^":"u3;Q,a,b,c,d,e,f",
gu:function(a){var z=new P.zQ(this,this.f,null,null)
z.b=this.d
return z},
gv:function(a){return this.Q},
tg:function(a,b){var z,y
if(typeof b==="string"&&b!=="__proto__"){z=this.a
if(z==null)return!1
return z[b]!=null}else if(typeof b==="number"&&(b&0x3ffffff)===b){y=this.b
if(y==null)return!1
return y[b]!=null}else return this.PR(b)},
PR:function(a){var z=this.c
if(z==null)return!1
return this.DF(z[this.rk(a)],a)>=0},
aN:function(a,b){var z,y
z=this.d
y=this.f
for(;z!=null;){b.$1(z.Q)
if(y!==this.f)throw H.b(new P.UV(this))
z=z.a}},
gFV:function(a){var z=this.d
if(z==null)throw H.b(new P.lj("No elements"))
return z.Q},
h:function(a,b){var z,y,x
if(typeof b==="string"&&b!=="__proto__"){z=this.a
if(z==null){y=Object.create(null)
y["<non-identifier-key>"]=y
delete y["<non-identifier-key>"]
this.a=y
z=y}return this.bQ(z,b)}else if(typeof b==="number"&&(b&0x3ffffff)===b){x=this.b
if(x==null){y=Object.create(null)
y["<non-identifier-key>"]=y
delete y["<non-identifier-key>"]
this.b=y
x=y}return this.bQ(x,b)}else return this.B7(b)},
B7:function(a){var z,y,x
z=this.c
if(z==null){z=P.T2()
this.c=z}y=this.rk(a)
x=z[y]
if(x==null)z[y]=[this.yo(a)]
else{if(this.DF(x,a)>=0)return!1
x.push(this.yo(a))}return!0},
bQ:function(a,b){if(a[b]!=null)return!1
a[b]=this.yo(b)
return!0},
yo:function(a){var z,y
z=new P.tj(a,null,null)
if(this.d==null){this.e=z
this.d=z}else{y=this.e
z.b=y
y.a=z
this.e=z}++this.Q
this.f=this.f+1&67108863
return z},
rk:function(a){return J.v1(a)&0x3ffffff},
DF:function(a,b){var z,y
if(a==null)return-1
z=a.length
for(y=0;y<z;++y)if(J.mG(a[y].gdA(),b))return y
return-1},
$isqC:1,
static:{T2:function(){var z=Object.create(null)
z["<non-identifier-key>"]=z
delete z["<non-identifier-key>"]
return z}}},
tj:{
"^":"a;dA:Q<,a,b"},
zQ:{
"^":"a;Q,a,b,c",
gk:function(){return this.c},
D:function(){var z=this.Q
if(this.a!==z.f)throw H.b(new P.UV(z))
else{z=this.b
if(z==null){this.c=null
return!1}else{this.c=z.Q
this.b=z.a
return!0}}}},
u3:{
"^":"Vj;"},
ar:{
"^":"E9;"},
E9:{
"^":"a+lD;",
$iszM:1,
$aszM:null,
$isqC:1},
lD:{
"^":"a;",
gu:function(a){return new H.a7(a,this.gv(a),0,null)},
Zv:function(a,b){return this.p(a,b)},
aN:function(a,b){var z,y
z=this.gv(a)
for(y=0;y<z;++y){b.$1(this.p(a,y))
if(z!==this.gv(a))throw H.b(new P.UV(a))}},
gFV:function(a){if(this.gv(a)===0)throw H.b(H.Wp())
return this.p(a,0)},
ez:function(a,b){return H.J(new H.A8(a,b),[null,null])},
Ay:function(a,b){var z,y,x
for(z=b.gu(b);z.D();){y=z.c
x=this.gv(a)
this.sv(a,x+1)
this.q(a,x,y)}},
X:function(a){return P.WE(a,"[","]")},
$iszM:1,
$aszM:null,
$isqC:1},
W0:{
"^":"r;Q,a",
$2:function(a,b){var z,y
z=this.Q
if(!z.Q)this.a.Q+=", "
z.Q=!1
z=this.a
y=z.Q+=H.d(a)
z.Q=y+": "
z.Q+=H.d(b)}},
lf:{
"^":"a;",
ez:function(a,b){return H.J(new H.xy(this,b),[H.Kp(this,0),null])},
X:function(a){return P.WE(this,"{","}")},
aN:function(a,b){var z
for(z=this.gu(this);z.D();)b.$1(z.c)},
gFV:function(a){var z=this.gu(this)
if(!z.D())throw H.b(H.Wp())
return z.c},
$isqC:1},
Vj:{
"^":"lf;"}}],["","",,P,{
"^":"",
hl:function(a){if(typeof a==="number"||typeof a==="boolean"||null==a)return J.Lz(a)
if(typeof a==="string")return JSON.stringify(a)
return P.os(a)},
os:function(a){var z=J.t(a)
if(!!z.$isr)return z.X(a)
return H.H9(a)},
ad:[function(a,b){return a==null?b==null:a===b},"$2","N3",4,0,6],
xv:[function(a){return H.CU(a)},"$1","J2",2,0,7],
z:function(a,b,c){var z,y
z=H.J([],[c])
for(y=J.Nx(a);y.D();)z.push(y.gk())
if(b)return z
z.fixed$length=Array
return z},
a2:{
"^":"a;"},
"+bool":0,
CP:{
"^":"FK;"},
"+double":0,
Ge:{
"^":"a;"},
LK:{
"^":"Ge;",
X:function(a){return"Throw of null."}},
AT:{
"^":"Ge;Q,a,b,c",
gZ2:function(){return"Invalid argument"+(!this.Q?"(s)":"")},
guF:function(){return""},
X:function(a){var z,y,x,w,v,u
z=this.b
y=z!=null?" ("+H.d(z)+")":""
z=this.c
x=z==null?"":": "+H.d(z)
w=this.gZ2()+y+x
if(!this.Q)return w
v=this.guF()
u=P.hl(this.a)
return w+v+": "+H.d(u)},
static:{p:function(a){return new P.AT(!1,null,null,a)}}},
bJ:{
"^":"AT;d,e,Q,a,b,c",
gZ2:function(){return"RangeError"},
guF:function(){var z,y,x
z=this.d
if(z==null){z=this.e
y=z!=null?": Not less than or equal to "+H.d(z):""}else{x=this.e
if(x==null)y=": Not greater than or equal to "+H.d(z)
else{if(typeof x!=="number")return x.A()
if(typeof z!=="number")return H.o(z)
if(x>z)y=": Not in range "+z+".."+x+", inclusive"
else y=x<z?": Valid value range is empty":": Only valid value is "+z}}return y},
static:{D:function(a,b,c){return new P.bJ(null,null,!0,a,b,"Value not in range")},TE:function(a,b,c,d,e){return new P.bJ(b,c,!0,a,d,"Invalid value")}}},
eY:{
"^":"AT;d,v:e>,Q,a,b,c",
gZ2:function(){return"RangeError"},
guF:function(){var z,y
P.hl(this.d)
z=": index should be less than "+H.d(this.e)
y=this.a
if(typeof y!=="number")return y.w()
return y<0?": index must not be negative":z},
static:{Cf:function(a,b,c,d,e){var z=e!=null?e:J.wS(b)
return new P.eY(b,z,!0,a,c,"Index out of range")}}},
ub:{
"^":"Ge;Q",
X:function(a){return"Unsupported operation: "+this.Q}},
ds:{
"^":"Ge;Q",
X:function(a){var z=this.Q
return z!=null?"UnimplementedError: "+H.d(z):"UnimplementedError"}},
lj:{
"^":"Ge;Q",
X:function(a){return"Bad state: "+this.Q}},
UV:{
"^":"Ge;Q",
X:function(a){var z=this.Q
if(z==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+H.d(P.hl(z))+"."}},
k5:{
"^":"a;",
X:function(a){return"Out of Memory"}},
t7:{
"^":"Ge;Q",
X:function(a){return"Reading static variable '"+this.Q+"' during its initialization"}},
HG:{
"^":"a;Q",
X:function(a){return"Exception: "+this.Q}},
kM:{
"^":"a;Q",
X:function(a){return"Expando:"+this.Q},
p:function(a,b){var z=H.VK(b,"expando$values")
return z==null?null:H.VK(z,this.Ux())},
q:function(a,b,c){var z=H.VK(b,"expando$values")
if(z==null){z=new P.a()
H.aw(b,"expando$values",z)}H.aw(z,this.Ux(),c)},
Ux:function(){var z,y
z=H.VK(this,"expando$key")
if(z==null){y=$.Ss
$.Ss=y+1
z="expando$key$"+y
H.aw(this,"expando$key",z)}return z}},
EH:{
"^":"a;"},
KN:{
"^":"FK;"},
"+int":0,
Ly:{
"^":"a;",
ez:function(a,b){return H.K1(this,b,H.W8(this,"Ly",0),null)},
aN:function(a,b){var z
for(z=this.gu(this);z.D();)b.$1(z.gk())},
zV:function(a,b){var z,y,x
z=this.gu(this)
if(!z.D())return""
y=new P.Rn("")
if(b===""){do y.Q+=H.d(z.gk())
while(z.D())}else{y.Q=H.d(z.gk())
for(;z.D();){y.Q+=b
y.Q+=H.d(z.gk())}}x=y.Q
return x.charCodeAt(0)==0?x:x},
gv:function(a){var z,y
z=this.gu(this)
for(y=0;z.D();)++y
return y},
gFV:function(a){var z=this.gu(this)
if(!z.D())throw H.b(H.Wp())
return z.gk()},
Zv:function(a,b){var z,y,x
if(b<0)H.vh(P.TE(b,0,null,"index",null))
for(z=this.gu(this),y=0;z.D();){x=z.gk()
if(b===y)return x;++y}throw H.b(P.Cf(b,this,"index",null,y))},
X:function(a){return P.EP(this,"(",")")}},
An:{
"^":"a;"},
zM:{
"^":"a;",
$aszM:null,
$isqC:1},
"+List":0,
w:{
"^":"a;"},
c8:{
"^":"a;",
X:function(a){return"null"}},
"+Null":0,
FK:{
"^":"a;"},
"+num":0,
a:{
"^":";",
m:function(a,b){return this===b},
giO:function(a){return H.wP(this)},
X:function(a){return H.H9(this)}},
I:{
"^":"a;"},
"+String":0,
Rn:{
"^":"a;IN:Q<",
gv:function(a){return this.Q.length},
X:function(a){var z=this.Q
return z.charCodeAt(0)==0?z:z},
static:{vg:function(a,b,c){var z=J.Nx(b)
if(!z.D())return a
if(c.length===0){do a+=H.d(z.gk())
while(z.D())}else{a+=H.d(z.gk())
for(;z.D();)a=a+c+H.d(z.gk())}return a}}}}],["","",,W,{
"^":"",
ZD:function(a){return a.replace(/^-ms-/,"ms-").replace(/-([\da-z])/ig,C.Vu)},
r3:function(a,b){return document.createElement(a)},
C0:function(a,b){a=536870911&a+b
a=536870911&a+((524287&a)<<10>>>0)
return a^a>>>6},
Up:function(a){a=536870911&a+((67108863&a)<<3>>>0)
a^=a>>>11
return 536870911&a+((16383&a)<<15>>>0)},
qE:{
"^":"cv;",
"%":"HTMLAppletElement|HTMLAudioElement|HTMLBRElement|HTMLBaseElement|HTMLBodyElement|HTMLCanvasElement|HTMLContentElement|HTMLDListElement|HTMLDataListElement|HTMLDetailsElement|HTMLDialogElement|HTMLDirectoryElement|HTMLDivElement|HTMLFontElement|HTMLFrameElement|HTMLFrameSetElement|HTMLHRElement|HTMLHeadElement|HTMLHeadingElement|HTMLHtmlElement|HTMLImageElement|HTMLLIElement|HTMLLabelElement|HTMLLegendElement|HTMLLinkElement|HTMLMarqueeElement|HTMLMediaElement|HTMLMenuElement|HTMLMenuItemElement|HTMLMeterElement|HTMLModElement|HTMLOListElement|HTMLOptGroupElement|HTMLOptionElement|HTMLParagraphElement|HTMLPictureElement|HTMLPreElement|HTMLProgressElement|HTMLQuoteElement|HTMLScriptElement|HTMLShadowElement|HTMLSourceElement|HTMLSpanElement|HTMLStyleElement|HTMLTableCaptionElement|HTMLTableCellElement|HTMLTableColElement|HTMLTableDataCellElement|HTMLTableElement|HTMLTableHeaderCellElement|HTMLTableRowElement|HTMLTableSectionElement|HTMLTemplateElement|HTMLTitleElement|HTMLTrackElement|HTMLUListElement|HTMLUnknownElement|HTMLVideoElement|PluginPlaceholderElement;HTMLElement"},
Gh:{
"^":"qE;",
X:function(a){return String(a)},
"%":"HTMLAnchorElement"},
fY:{
"^":"qE;",
X:function(a){return String(a)},
"%":"HTMLAreaElement"},
IF:{
"^":"qE;oc:name=",
"%":"HTMLButtonElement"},
OM:{
"^":"KV;v:length=",
"%":"CDATASection|CharacterData|Comment|ProcessingInstruction|Text"},
oJ:{
"^":"BV;v:length=",
hV:function(a,b,c,d){var z=this.Qe(a,b)
if(c==null)c=""
if(d==null)d=""
a.setProperty(z,c,d)
return},
MW:function(a,b,c){return this.hV(a,b,c,null)},
Qe:function(a,b){var z,y
z=$.pJ()
y=z[b]
if(typeof y==="string")return y
y=W.ZD(b) in a?b:P.O2()+b
z[b]=y
return y},
"%":"CSS2Properties|CSSStyleDeclaration|MSStyleCSSProperties"},
BV:{
"^":"Gv+RE;"},
Xn:{
"^":"vY;Q,a",
hV:function(a,b,c,d){this.a.aN(0,new W.pV(b,c,d))},
MW:function(a,b,c){return this.hV(a,b,c,null)},
XG:function(a){this.a=H.J(new H.A8(P.z(this.Q,!0,null),new W.A5()),[null,null])},
static:{HD:function(a){var z=new W.Xn(a,null)
z.XG(a)
return z}}},
vY:{
"^":"a+RE;"},
A5:{
"^":"r;",
$1:function(a){return J.EJ(a)}},
pV:{
"^":"r;Q,a,b",
$1:function(a){return J.X9(a,this.Q,this.a,this.b)}},
RE:{
"^":"a;"},
QF:{
"^":"KV;",
Wk:function(a,b){return a.querySelector(b)},
Md:function(a,b){return new W.wz(a.querySelectorAll(b))},
"%":"Document|HTMLDocument|XMLDocument"},
hs:{
"^":"KV;",
Md:function(a,b){return new W.wz(a.querySelectorAll(b))},
Wk:function(a,b){return a.querySelector(b)},
"%":"DocumentFragment|ShadowRoot"},
Nh:{
"^":"Gv;",
X:function(a){return String(a)},
"%":"DOMException"},
IB:{
"^":"Gv;fg:height=,Bb:left=,G6:top=,N:width=",
X:function(a){return"Rectangle ("+H.d(a.left)+", "+H.d(a.top)+") "+H.d(this.gN(a))+" x "+H.d(this.gfg(a))},
m:function(a,b){var z,y,x
if(b==null)return!1
z=J.t(b)
if(!z.$istn)return!1
y=a.left
x=z.gBb(b)
if(y==null?x==null:y===x){y=a.top
x=z.gG6(b)
if(y==null?x==null:y===x){y=this.gN(a)
x=z.gN(b)
if(y==null?x==null:y===x){y=this.gfg(a)
z=z.gfg(b)
z=y==null?z==null:y===z}else z=!1}else z=!1}else z=!1
return z},
giO:function(a){var z,y,x,w
z=J.v1(a.left)
y=J.v1(a.top)
x=J.v1(this.gN(a))
w=J.v1(this.gfg(a))
return W.Up(W.C0(W.C0(W.C0(W.C0(0,z),y),x),w))},
$istn:1,
$astn:Cq,
"%":";DOMRectReadOnly"},
wz:{
"^":"ar;Q",
gv:function(a){return this.Q.length},
p:function(a,b){var z=this.Q
if(b>>>0!==b||b>=z.length)return H.e(z,b)
return z[b]},
q:function(a,b,c){throw H.b(new P.ub("Cannot modify list"))},
sv:function(a,b){throw H.b(new P.ub("Cannot modify list"))},
gFV:function(a){return C.t5.gFV(this.Q)},
gO:function(a){return W.HD(this)},
$asar:Cq,
$aszM:Cq,
$iszM:1,
$isqC:1},
cv:{
"^":"KV;O:style=",
gQg:function(a){return new W.i7(a)},
Md:function(a,b){return new W.wz(a.querySelectorAll(b))},
X:function(a){return a.localName},
Wk:function(a,b){return a.querySelector(b)},
$iscv:1,
$isa:1,
"%":"SVGAElement|SVGAltGlyphDefElement|SVGAltGlyphElement|SVGAltGlyphItemElement|SVGAnimateElement|SVGAnimateMotionElement|SVGAnimateTransformElement|SVGAnimationElement|SVGCircleElement|SVGClipPathElement|SVGComponentTransferFunctionElement|SVGCursorElement|SVGDefsElement|SVGDescElement|SVGDiscardElement|SVGElement|SVGEllipseElement|SVGFEBlendElement|SVGFEColorMatrixElement|SVGFEComponentTransferElement|SVGFECompositeElement|SVGFEConvolveMatrixElement|SVGFEDiffuseLightingElement|SVGFEDisplacementMapElement|SVGFEDistantLightElement|SVGFEDropShadowElement|SVGFEFloodElement|SVGFEFuncAElement|SVGFEFuncBElement|SVGFEFuncGElement|SVGFEFuncRElement|SVGFEGaussianBlurElement|SVGFEImageElement|SVGFEMergeElement|SVGFEMergeNodeElement|SVGFEMorphologyElement|SVGFEOffsetElement|SVGFEPointLightElement|SVGFESpecularLightingElement|SVGFESpotLightElement|SVGFETileElement|SVGFETurbulenceElement|SVGFilterElement|SVGFontElement|SVGFontFaceElement|SVGFontFaceFormatElement|SVGFontFaceNameElement|SVGFontFaceSrcElement|SVGFontFaceUriElement|SVGForeignObjectElement|SVGGElement|SVGGeometryElement|SVGGlyphElement|SVGGlyphRefElement|SVGGradientElement|SVGGraphicsElement|SVGHKernElement|SVGImageElement|SVGLineElement|SVGLinearGradientElement|SVGMPathElement|SVGMarkerElement|SVGMaskElement|SVGMetadataElement|SVGMissingGlyphElement|SVGPathElement|SVGPatternElement|SVGPolygonElement|SVGPolylineElement|SVGRadialGradientElement|SVGRectElement|SVGSVGElement|SVGScriptElement|SVGSetElement|SVGStopElement|SVGStyleElement|SVGSwitchElement|SVGSymbolElement|SVGTSpanElement|SVGTextContentElement|SVGTextElement|SVGTextPathElement|SVGTextPositioningElement|SVGTitleElement|SVGUseElement|SVGVKernElement|SVGViewElement;Element"},
Fs:{
"^":"qE;oc:name=",
"%":"HTMLEmbedElement"},
D0:{
"^":"Gv;",
"%":"DOMWindow|Window;EventTarget"},
as:{
"^":"qE;oc:name=",
"%":"HTMLFieldSetElement"},
Yu:{
"^":"qE;v:length=,oc:name=",
"%":"HTMLFormElement"},
tb:{
"^":"qE;oc:name=",
"%":"HTMLIFrameElement"},
Mi:{
"^":"qE;oc:name=",
"%":"HTMLInputElement"},
tt:{
"^":"qE;oc:name=",
"%":"HTMLKeygenElement"},
M6:{
"^":"qE;oc:name=",
"%":"HTMLMapElement"},
Ee:{
"^":"qE;oc:name=",
"%":"HTMLMetaElement"},
KV:{
"^":"D0;KV:parentNode=,a4:textContent}",
X:function(a){var z=a.nodeValue
return z==null?this.VE(a):z},
Y:function(a,b){return a.appendChild(b)},
$isa:1,
"%":"DocumentType;Node"},
BH:{
"^":"ec;",
gv:function(a){return a.length},
p:function(a,b){if(b>>>0!==b||b>=a.length)throw H.b(P.Cf(b,a,null,null,null))
return a[b]},
q:function(a,b,c){throw H.b(new P.ub("Cannot assign element of immutable List."))},
sv:function(a,b){throw H.b(new P.ub("Cannot resize immutable List."))},
gFV:function(a){if(a.length>0)return a[0]
throw H.b(new P.lj("No elements"))},
Zv:function(a,b){if(b<0||b>=a.length)return H.e(a,b)
return a[b]},
$iszM:1,
$aszM:function(){return[W.KV]},
$isqC:1,
$isXj:1,
"%":"NodeList|RadioNodeList"},
RA:{
"^":"Gv+lD;",
$iszM:1,
$aszM:function(){return[W.KV]},
$isqC:1},
ec:{
"^":"RA+Gm;",
$iszM:1,
$aszM:function(){return[W.KV]},
$isqC:1},
G7:{
"^":"qE;oc:name=",
"%":"HTMLObjectElement"},
wL:{
"^":"qE;oc:name=",
"%":"HTMLOutputElement"},
me:{
"^":"qE;oc:name=",
"%":"HTMLParamElement"},
lp:{
"^":"qE;v:length=,oc:name=",
"%":"HTMLSelectElement"},
FB:{
"^":"qE;oc:name=",
"%":"HTMLTextAreaElement"},
UM:{
"^":"KV;oc:name=",
sa4:function(a,b){a.textContent=b},
"%":"Attr"},
YC:{
"^":"Gv;fg:height=,Bb:left=,G6:top=,N:width=",
X:function(a){return"Rectangle ("+H.d(a.left)+", "+H.d(a.top)+") "+H.d(a.width)+" x "+H.d(a.height)},
m:function(a,b){var z,y,x
if(b==null)return!1
z=J.t(b)
if(!z.$istn)return!1
y=a.left
x=z.gBb(b)
if(y==null?x==null:y===x){y=a.top
x=z.gG6(b)
if(y==null?x==null:y===x){y=a.width
x=z.gN(b)
if(y==null?x==null:y===x){y=a.height
z=z.gfg(b)
z=y==null?z==null:y===z}else z=!1}else z=!1}else z=!1
return z},
giO:function(a){var z,y,x,w
z=J.v1(a.left)
y=J.v1(a.top)
x=J.v1(a.width)
w=J.v1(a.height)
return W.Up(W.C0(W.C0(W.C0(W.C0(0,z),y),x),w))},
$istn:1,
$astn:Cq,
"%":"ClientRect"},
w4:{
"^":"IB;",
gfg:function(a){return a.height},
gN:function(a){return a.width},
"%":"DOMRect"},
rh:{
"^":"x5;",
gv:function(a){return a.length},
p:function(a,b){if(b>>>0!==b||b>=a.length)throw H.b(P.Cf(b,a,null,null,null))
return a[b]},
q:function(a,b,c){throw H.b(new P.ub("Cannot assign element of immutable List."))},
sv:function(a,b){throw H.b(new P.ub("Cannot resize immutable List."))},
gFV:function(a){if(a.length>0)return a[0]
throw H.b(new P.lj("No elements"))},
Zv:function(a,b){if(b<0||b>=a.length)return H.e(a,b)
return a[b]},
$iszM:1,
$aszM:function(){return[W.KV]},
$isqC:1,
$isXj:1,
"%":"MozNamedAttrMap|NamedNodeMap"},
nN:{
"^":"Gv+lD;",
$iszM:1,
$aszM:function(){return[W.KV]},
$isqC:1},
x5:{
"^":"nN+Gm;",
$iszM:1,
$aszM:function(){return[W.KV]},
$isqC:1},
D9:{
"^":"a;",
aN:function(a,b){var z,y,x,w
for(z=this.gvc(),y=z.length,x=0;x<z.length;z.length===y||(0,H.lk)(z),++x){w=z[x]
b.$2(w,this.p(0,w))}},
gvc:function(){var z,y,x,w
z=this.Q.attributes
y=H.J([],[P.I])
for(x=z.length,w=0;w<x;++w){if(w>=z.length)return H.e(z,w)
if(this.Bs(z[w])){if(w>=z.length)return H.e(z,w)
y.push(J.O6(z[w]))}}return y}},
i7:{
"^":"D9;Q",
p:function(a,b){return this.Q.getAttribute(b)},
gv:function(a){return this.gvc().length},
Bs:function(a){return a.namespaceURI==null}},
Gm:{
"^":"a;",
gu:function(a){return new W.W9(a,this.gv(a),-1,null)},
$iszM:1,
$aszM:null,
$isqC:1},
W9:{
"^":"a;Q,a,b,c",
D:function(){var z,y
z=this.b+1
y=this.a
if(z<y){this.c=J.Tf(this.Q,z)
this.b=z
return!0}this.c=null
this.b=y
return!1},
gk:function(){return this.c}}}],["","",,P,{
"^":""}],["","",,P,{
"^":""}],["","",,P,{
"^":"",
C:function(a,b){if(typeof a!=="number")throw H.b(P.p(a))
if(typeof b!=="number")throw H.b(P.p(b))
if(a>b)return b
if(a<b)return a
if(typeof b==="number"){if(typeof a==="number")if(a===0)return(a+b)*a*b
if(a===0&&C.ON.gOo(b)||C.ON.gG0(b))return b
return a}return a},
u:function(a,b){var z
if(typeof a!=="number")throw H.b(P.p(a))
if(typeof b!=="number")throw H.b(P.p(b))
if(a>b)return a
if(a<b)return b
if(typeof b==="number"){if(typeof a==="number")if(a===0)return a+b
if(C.ON.gG0(b))return b
return a}if(b===0)z=a===0?1/a<0:a<0
else z=!1
if(z)return b
return a}}],["","",,P,{
"^":"",
dg:function(){var z=$.az
if(z==null){z=J.Vw(window.navigator.userAgent,"Opera",0)
$.az=z}return z},
O2:function(){var z,y
z=$.aj
if(z!=null)return z
y=$.w5
if(y==null){y=J.Vw(window.navigator.userAgent,"Firefox",0)
$.w5=y}if(y===!0)z="-moz-"
else{y=$.EM
if(y==null){y=P.dg()!==!0&&J.Vw(window.navigator.userAgent,"Trident/",0)
$.EM=y}if(y===!0)z="-ms-"
else z=P.dg()===!0?"-o-":"-webkit-"}$.aj=z
return z}}],["","",,E,{
"^":"",
Q:function(){var z,y,x,w,v
z=document.querySelector("#chart")
y=$.S()
x=new F.G3([],null,null,null,P.V())
x.a=y
w=new F.M(z,x,null,null,null,null,null,!1,!0,"y Axis",P.T(["top",20,"right",20,"bottom",250,"left",50]),null)
v=z.getBoundingClientRect()
w.z=J.U(v)
w.ch=J.O(v)
w.d="Number of animals"
w.e=P.T(["top",0,"right",200,"bottom",250,"left",50])
w.b=!0
w.y=$.Z()
w.am()}},1]]
setupProgram(dart,0)
J.Qc=function(a){if(typeof a=="number")return J.F.prototype
if(typeof a=="string")return J.E.prototype
if(a==null)return a
if(!(a instanceof P.a))return J.kd.prototype
return a}
J.R=function(a){if(a==null)return a
if(typeof a!="object")return a
if(a instanceof P.a)return a
return J.ks(a)}
J.U6=function(a){if(typeof a=="string")return J.E.prototype
if(a==null)return a
if(a.constructor==Array)return J.G.prototype
if(typeof a!="object")return a
if(a instanceof P.a)return a
return J.ks(a)}
J.Wx=function(a){if(typeof a=="number")return J.F.prototype
if(a==null)return a
if(!(a instanceof P.a))return J.kd.prototype
return a}
J.t=function(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.im.prototype
return J.VA.prototype}if(typeof a=="string")return J.E.prototype
if(a==null)return J.PE.prototype
if(typeof a=="boolean")return J.yE.prototype
if(a.constructor==Array)return J.G.prototype
if(typeof a!="object")return a
if(a instanceof P.a)return a
return J.ks(a)}
J.w1=function(a){if(a==null)return a
if(a.constructor==Array)return J.G.prototype
if(typeof a!="object")return a
if(a instanceof P.a)return a
return J.ks(a)}
J.EJ=function(a){return J.R(a).gO(a)}
J.Gw=function(a,b){return J.Wx(a).WZ(a,b)}
J.Lz=function(a){return J.t(a).X(a)}
J.MK=function(a,b){return J.R(a).Md(a,b)}
J.Nx=function(a){return J.w1(a).gu(a)}
J.O=function(a){return J.R(a).gfg(a)}
J.O6=function(a){return J.R(a).goc(a)}
J.RG=function(a,b){return J.R(a).Y(a,b)}
J.Tf=function(a,b){if(a.constructor==Array||typeof a=="string"||H.wV(a,a[init.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.U6(a).p(a,b)}
J.U=function(a){return J.R(a).gN(a)}
J.Vs=function(a){return J.R(a).gQg(a)}
J.Vw=function(a,b,c){return J.U6(a).Is(a,b,c)}
J.WB=function(a,b){if(typeof a=="number"&&typeof b=="number")return a+b
return J.Qc(a).g(a,b)}
J.X9=function(a,b,c,d){return J.R(a).hV(a,b,c,d)}
J.c1=function(a,b){return J.R(a).Wk(a,b)}
J.cE=function(a){return J.Wx(a).gG0(a)}
J.i4=function(a,b){return J.w1(a).Zv(a,b)}
J.kH=function(a,b){return J.w1(a).aN(a,b)}
J.kl=function(a,b){return J.w1(a).ez(a,b)}
J.lX=function(a,b){if(typeof a=="number"&&typeof b=="number")return a*b
return J.Qc(a).R(a,b)}
J.mG=function(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.t(a).m(a,b)}
J.n9=function(a){return J.w1(a).gFV(a)}
J.t3=function(a,b){return J.R(a).sa4(a,b)}
J.v1=function(a){return J.t(a).giO(a)}
J.vA=function(a,b,c){return J.R(a).MW(a,b,c)}
J.wS=function(a){return J.U6(a).gv(a)}
I.uL=function(a){a.immutable$list=Array
a.fixed$length=Array
return a}
var $=I.p
C.Nm=J.G.prototype
C.ON=J.VA.prototype
C.jn=J.im.prototype
C.CD=J.F.prototype
C.xB=J.E.prototype
C.t5=W.BH.prototype
C.ZQ=J.iC.prototype
C.vB=J.kd.prototype
C.Eq=new P.k5()
C.Mc=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
C.lR=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
C.w2=function getTagFallback(o) {
  var constructor = o.constructor;
  if (typeof constructor == "function") {
    var name = constructor.name;
    if (typeof name == "string" &&
        name.length > 2 &&
        name !== "Object" &&
        name !== "Function.prototype") {
      return name;
    }
  }
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
C.XQ=function(hooks) { return hooks; }

C.ur=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var ua = navigator.userAgent;
    if (ua.indexOf("DumpRenderTree") >= 0) return hooks;
    if (ua.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
C.Jh=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
C.M1=function() {
  function typeNameInChrome(o) {
    var constructor = o.constructor;
    if (constructor) {
      var name = constructor.name;
      if (name) return name;
    }
    var s = Object.prototype.toString.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = Object.prototype.toString.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (self.HTMLElement && object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof navigator == "object";
  return {
    getTag: typeNameInChrome,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
C.hQ=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
C.Vu=function(_, letter) { return letter.toUpperCase(); }
C.yT=I.uL(["div"])
$.yj=0
$.mJ=null
$.P4=null
$.NF=null
$.TX=null
$.x7=null
$.nw=null
$.vv=null
$.Bv=null
$.Ss=0
$.az=null
$.EM=null
$.w5=null
$.aj=null
$=null
init.isHunkLoaded=function(a){return!!$dart_deferred_initializers$[a]}
init.deferredInitialized=new Object(null)
init.isHunkInitialized=function(a){return init.deferredInitialized[a]}
init.initializeLoadedHunk=function(a){$dart_deferred_initializers$[a](S0,$)
init.deferredInitialized[a]=true}
init.deferredLibraryUris={}
init.deferredLibraryHashes={};(function(a){var z=3
for(var y=0;y<a.length;y+=z){var x=a[y]
var w=a[y+1]
var v=a[y+2]
I.$lazy(x,w,v)}})(["ir","Ai",function(){return new P.kM("__data__")},"WO","Hn",function(){return P.tM(C.yT,null)},"W","S",function(){return[2062260,16744206,2924588,14034728,9725885,9197131,14907330,8355711,12369186,1556175]},"xg","xb",function(){return[]},"fd","pJ",function(){return{}},"P","Z",function(){return[[P.T(["x","White","y","Cats","value",21]),P.T(["x","Black","y","Cats","value",12]),P.T(["x","Ginger","y","Cats","value",8])],[P.T(["x","White","y","Dogs","value",11]),P.T(["x","Black","y","Dogs","value",18]),P.T(["x","Ginger","y","Dogs","value",15])]]}])
I=I.$finishIsolateConstructor(I)
$=new I()
init.metadata=[]
init.types=[{func:1,void:true,args:[,,]},{func:1,ret:{func:1,ret:P.a,args:[P.a]},args:[P.FK,P.FK]},{func:1,ret:P.EH,args:[,,,,]},{func:1,ret:P.I,args:[,,]},{func:1,ret:P.a2,args:[,,]},{func:1,ret:P.KN,args:[,]},{func:1,ret:P.a2,args:[P.a,P.a]},{func:1,ret:P.KN,args:[P.a]}]
function convertToFastObject(a){function MyClass(){}MyClass.prototype=a
new MyClass()
return a}function convertToSlowObject(a){a.__MAGIC_SLOW_PROPERTY=1
delete a.__MAGIC_SLOW_PROPERTY
return a}A=convertToFastObject(A)
B=convertToFastObject(B)
C=convertToFastObject(C)
D=convertToFastObject(D)
E=convertToFastObject(E)
F=convertToFastObject(F)
G=convertToFastObject(G)
H=convertToFastObject(H)
J=convertToFastObject(J)
K=convertToFastObject(K)
L=convertToFastObject(L)
M=convertToFastObject(M)
N=convertToFastObject(N)
O=convertToFastObject(O)
P=convertToFastObject(P)
Q=convertToFastObject(Q)
R=convertToFastObject(R)
S=convertToFastObject(S)
T=convertToFastObject(T)
U=convertToFastObject(U)
V=convertToFastObject(V)
W=convertToFastObject(W)
X=convertToFastObject(X)
Y=convertToFastObject(Y)
Z=convertToFastObject(Z)
function init(){I.p=Object.create(null)
init.allClasses=Object.create(null)
init.getTypeFromName=function(a){return init.allClasses[a]}
init.interceptorsByTag=Object.create(null)
init.leafTags=Object.create(null)
init.finishedClasses=Object.create(null)
I.$lazy=function(a,b,c,d,e){if(!init.lazies)init.lazies=Object.create(null)
init.lazies[a]=b
e=e||I.p
var z={}
var y={}
e[a]=z
e[b]=function(){var x=this[a]
try{if(x===z){this[a]=y
try{x=this[a]=c()}finally{if(x===z)this[a]=null}}else if(x===y)H.eQ(d||a)
return x}finally{this[b]=function(){return this[a]}}}}
I.$finishIsolateConstructor=function(a){var z=a.p
function Isolate(){var y=Object.keys(z)
for(var x=0;x<y.length;x++){var w=y[x]
this[w]=z[w]}var v=init.lazies
var u=v?Object.keys(v):[]
for(var x=0;x<u.length;x++)this[v[u[x]]]=null
function ForceEfficientMap(){}ForceEfficientMap.prototype=this
new ForceEfficientMap()
for(var x=0;x<u.length;x++){var t=v[u[x]]
this[t]=z[t]}}Isolate.prototype=a.prototype
Isolate.prototype.constructor=Isolate
Isolate.p=z
Isolate.uL=a.uL
return Isolate}}!function(){function intern(a){var u={}
u[a]=1
return Object.keys(convertToFastObject(u))[0]}init.getIsolateTag=function(a){return intern("___dart_"+a+init.isolateTag)}
var z="___dart_isolate_tags_"
var y=Object[z]||(Object[z]=Object.create(null))
var x="_ZxYxX"
for(var w=0;;w++){var v=intern(x+"_"+w+"_")
if(!(v in y)){y[v]=1
init.isolateTag=v
break}}init.dispatchPropertyName=init.getIsolateTag("dispatch_record")}();(function(a){if(typeof document==="undefined"){a(null)
return}if(document.currentScript){a(document.currentScript)
return}var z=document.scripts
function onLoad(b){for(var x=0;x<z.length;++x)z[x].removeEventListener("load",onLoad,false)
a(b.target)}for(var y=0;y<z.length;++y)z[y].addEventListener("load",onLoad,false)})(function(a){init.currentScript=a
if(typeof dartMainRunner==="function")dartMainRunner(E.Q,[])
else E.Q([])})})()