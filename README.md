# Lines of Code Reporter

Calculates and publishes lines of code report in GitHub Actions as Checksuite.

### Note:- The scope of this project is limited to Calculating lines of code and publishing report.
###  If you like my Github Action, please **STAR ⭐** it.

## Samples


Calculates and publishes lines of code report in GitHub Actions as Checksuite.
Here's a quick example of how to use this action in your own GitHub Workflows.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    
      - name: Calculate Lines of Code
        id: loc
        uses: PavanMudigonda/lines-of-code-reporter@v1.4
        with:
          directory: src
          include_lang: "JavaScript,TypeScript"     #Optional # Comma Seperated
          exclude_lang: "PowerShell,Shell,Go"       #Optional # Comma Seperated
          exclude_dir: "node_modules,.github"       #Optional # Comma Seperated
          include_ext: "c,ps1,go,sh,ts,js"          #Optional # Comma Seperated

      # Publish Lines of Code Summary  # Optional
     - name: Add Lines of Code Summary
       run: echo "${{ steps.loc.outputs.lines-of-code-summary }}" >> $GITHUB_STEP_SUMMARY

      - name: print output # Optional
        shell: pwsh
        run: | 
          Write-Host 'Total Lines of Code...:  ${{ steps.lines-of-code-reporter.outputs.total_lines }}'
          Write-Host 'Lines of Code Markdown Report Path...:  ${{ steps.lines-of-code-reporter.outputs.loc_report }}' 
                    
```


### Inputs

This Action defines the following formal inputs.

| Name | Req | Description
|-|-|-|
|**`directory`**  | false | Directory where lines of code needs to be calculated. Defaults to ${{ github.workspace }}
|**`github_token`** | false | Input the GITHUB TOKEN Or Personal Access Token you would like to use. Recommended to use GitHub auto generated token ${{ secrets.GITHUB_TOKEN }}
|**`skip_check_run`** | false | If true, will skip attaching the Coverage Result report to the Workflow Run using a Check Run. 
|**`exclude_dir`**  | false | directories that need to be excluded, comma seperated, example ".github,node_modules,.gitignore".Directories named .bzr, .cvs, .hg, .git, .svn, and .snapshot are always excluded. Also please note all files in .gitignore are excluded by default. Please see Note below the table.
|**`exclude_lang`**  | false | languages types that need to be excluded, comma seperated, Scroll to "Languages Supported" section, example "JavaScript,PowerShell,TypeScript". Please see alternative filter "include_ext" based on file extension.
|**`include_lang`**  | false | languages types that need to be included, comma seperated. Scroll to "Languages Supported" section. example "JavaScript,PowerShell,TypeScript"
|**`include_ext`**  | false | extention types that need to be included, comma seperated. Scroll to "Extensions Supported" section. example "c,sh,ts,js". See alternative filter "include_lang"

Note:- This Action will invoke 'git ls-files' to get a file list and 'git submodule status' to get a list of submodules whose contents will be ignored.  See also --git which accepts git commit hashes and branch names.  The primary benefit is this action then skip files explicitly excluded by git, ie, those in .gitignore.

### Outputs

This Action defines the following formal outputs.

| Name | Description
|-|-|
| **`loc_report`** | Lines of Code Report output
| **`total_lines_int`** | Total Code Lines output as int
| **`total_lines_string`** | Total Code Lines output as int with comma seperation

### Sample Screenshot

<img width="881" alt="image" src="https://user-images.githubusercontent.com/86745613/164104335-2aec8669-9d15-4fc4-9517-35b4b8ba1f30.png">

<img width="1013" alt="image" src="https://user-images.githubusercontent.com/86745613/164104559-9a27a09d-6abc-4a6e-96d0-e2decd00dff2.png">

### Sample Github Actions workflow 

https://github.com/PavanMudigonda/lines-of-code-reporter/blob/main/.github/workflows/main.yml

### PowerShell GitHub Action

This Action is implemented as a [PowerShell GitHub Action](https://github.com/ebekker/pwsh-github-action-base).


## Languages Supported

</pre>

# Recognized Languages and Corresponding File Extensions.

<pre>

ABAP                       (abap)
ActionScript               (as)
Ada                        (ada, adb, ads, pad)
ADSO/IDSM                  (adso)
Agda                       (agda, lagda)
AMPLE                      (ample, dofile, startup)
Ant                        (build.xml, build.xml)
ANTLR Grammar              (g, g4)
Apex Class                 (cls)
Apex Trigger               (trigger)
APL                        (apl, apla, aplc, aplf, apli, apln, aplo, dyalog, dyapp, mipage)
Arduino Sketch             (ino, pde)
AsciiDoc                   (adoc, asciidoc)
ASP                        (asa, ashx, asp, axd)
ASP.NET                    (asax, ascx, asmx, aspx, master, sitemap, webinfo)
AspectJ                    (aj)
Assembly                   (a51, asm, nasm, S, s)
AutoHotkey                 (ahk, ahkl)
awk                        (auk, awk, gawk, mawk, nawk)
Bazel                      (BUILD)
BizTalk Orchestration      (odx)
BizTalk Pipeline           (btp)
Blade                      (blade, blade.php)
Bourne Again Shell         (bash)
Bourne Shell               (sh)
BrightScript               (brs)
builder                    (xml.builder)
C                          (c, cats, ec, idc, pgc)
C Shell                    (csh, tcsh)
C#                         (cs)
C# Designer                (designer.cs)
C++                        (C, c++, cc, CPP, cpp, cxx, h++, inl, ipp, pcc, tcc, tpp)
C/C++ Header               (H, h, hh, hpp, hxx)
Cake Build Script          (cake)
CCS                        (ccs)
Chapel                     (chpl)
Clean                      (dcl, icl)
Clojure                    (boot, cl2, clj, cljs.hl, cljscm, cljx, hic, riemann.config)
ClojureC                   (cljc)
ClojureScript              (cljs)
CMake                      (cmake, cmake.in, CMakeLists.txt)
COBOL                      (CBL, cbl, ccp, COB, cob, cobol, cpy)
CoffeeScript               (_coffee, cakefile, cjsx, coffee, iced)
ColdFusion                 (cfm, cfml)
ColdFusion CFScript        (cfc)
Coq                        (v)
Crystal                    (cr)
CSON                       (cson)
CSS                        (css)
CSV                        (csv)
Cucumber                   (feature)
CUDA                       (cu, cuh)
Cython                     (pxd, pxi, pyx)
D                          (d)
DAL                        (da)
Dart                       (dart)
Delphi Form                (dfm)
DenizenScript              (dsc)
Derw                       (derw)
dhall                      (dhall)
DIET                       (dt)
diff                       (diff, patch)
DITA                       (dita)
Dockerfile                 (Dockerfile, dockerfile)
DOORS Extension Language   (dxl)
DOS Batch                  (BAT, bat, BTM, btm, CMD, cmd)
Drools                     (drl)
DTD                        (dtd)
dtrace                     (d)
ECPP                       (ecpp)
EEx                        (eex)
EJS                        (ejs)
Elixir                     (ex, exs)
Elm                        (elm)
Embedded Crystal           (ecr)
ERB                        (ERB, erb)
Erlang                     (app.src, emakefile, erl, hrl, rebar.config, rebar.config.lock, rebar.lock, xrl, yrl)
Expect                     (exp)
F#                         (fsi, fs, fs)
F# Script                  (fsx)
Fennel                     (fnl)
Finite State Language      (fsl, jssm)
Fish Shell                 (fish)
Flatbuffers                (fbs)
Focus                      (focexec)
Forth                      (4th, e4, f83, fb, forth, fpm, fr, frt, ft, fth, rx, fs, f, for)
Fortran 77                 (F, F77, f77, FOR, FTN, ftn, pfo, f, for)
Fortran 90                 (F90, f90)
Fortran 95                 (F95, f95)
Freemarker Template        (ftl)
Futhark                    (fut)
FXML                       (fxml)
GDScript                   (gd)
Gencat NLS                 (msg)
Glade                      (glade, ui)
Gleam                      (gleam)
GLSL                       (comp, fp, frag, frg, fsh, fshader, geo, geom, glsl, glslv, gshader, tesc, tese, vert, vrx, vsh, vshader)
Go                         (go)
Godot Resource             (tres)
Godot Scene                (tscn)
Godot Shaders              (gdshader)
Gradle                     (gradle, gradle.kts)
Grails                     (gsp)
GraphQL                    (gql, graphql, graphqls)
Groovy                     (gant, groovy, grt, gtpl, gvy, jenkinsfile)
Haml                       (haml, haml.deface)
Handlebars                 (handlebars, hbs)
Harbour                    (hb)
Haskell                    (hs, hsc, lhs)
Haxe                       (hx, hxsl)
HCL                        (hcl, nomad, tf, tfvars)
HLSL                       (cg, cginc, fxh, hlsl, hlsli, shader)
Hoon                       (hoon)
HTML                       (htm, html, html.hl, xht)
HTML EEx                   (heex)
IDL                        (dlm, idl, pro)
Idris                      (idr)
Igor Pro                   (ipf)
Imba                       (imba)
INI                        (buildozer.spec, ini, lektorproject, prefs)
InstallShield              (ism)
IPL                        (ipl)
Java                       (java)
JavaScript                 (_js, bones, cjs, es6, jake, jakefile, js, jsb, jscad, jsfl, jsm, jss, mjs, njs, pac, sjs, ssjs, xsjs, xsjslib)
JavaServer Faces           (jsf)
JCL                        (jcl)
Jinja Template             (jinja, jinja2)
JSON                       (arcconfig, avsc, composer.lock, geojson, gltf, har, htmlhintrc, json, json-tmlanguage, jsonl, mcmeta, mcmod.info, tern-config, tern-project, tfstate, tfstate.backup, topojson, watchmanconfig, webapp, webmanifest, yyp)
JSON5                      (json5)
JSP                        (jsp, jspf)
JSX                        (jsx)
Julia                      (jl)
Juniper Junos              (junos)
Jupyter Notebook           (ipynb)
kvlang                     (kv)
Kermit                     (ksc)
Korn Shell                 (ksh)
Kotlin                     (kt, ktm, kts)
Lean                       (hlean, lean)
Lem                        (lem)
LESS                       (less)
lex                        (l, lex)
LFE                        (lfe)
liquid                     (liquid)
Lisp                       (asd, el, lisp, lsp, cl, jl)
Literate Idris             (lidr)
LiveLink OScript           (oscript)
LLVM IR                    (ll)
Logos                      (x, xm)
Logtalk                    (lgt, logtalk)
Lua                        (lua, nse, p8, pd_lua, rbxs, wlua)
m4                         (ac, m4)
make                       (am, Gnumakefile, gnumakefile, Makefile, makefile, mk)
Mako                       (mako, mao)
Markdown                   (contents.lr, markdown, md, mdown, mdwn, mdx, mkd, mkdn, mkdown, ronn, workbook)
Mathematica                (cdf, ma, mathematica, mt, nbp, wl, wlt, m)
MATLAB                     (m)
Maven                      (pom, pom.xml)
Meson                      (meson.build)
Metal                      (metal)
Modula3                    (i3, ig, m3, mg)
Mojo                       (mojom)
MSBuild script             (btproj, csproj, msbuild, vcproj, wdproj, wixproj)
MUMPS                      (mps, m)
Mustache                   (mustache)
MXML                       (mxml)
NAnt script                (build)
NASTRAN DMAP               (dmap)
Nemerle                    (n)
Nim                        (nim, nim.cfg, nimble, nimrod, nims)
Nix                        (nix)
Objective-C                (m)
Objective-C++              (mm)
OCaml                      (eliom, eliomi, ml, ml4, mli, mll, mly)
Odin                       (odin)
OpenCL                     (cl)
Oracle Forms               (fmt)
Oracle PL/SQL              (bod, fnc, prc, spc, trg)
Oracle Reports             (rex)
Pascal                     (dpr, lpr, p, pas, pascal)
Pascal/Puppet              (pp)
Patran Command Language    (pcl, ses)
PEG                        (peg)
peg.js                     (pegjs)
peggy                      (peggy)
Perl                       (ack, al, cpanfile, makefile.pl, perl, ph, plh, plx, pm, psgi, rexfile, pl, p6)
PHP                        (aw, ctp, phakefile, php, php3, php4, php5, php_cs, php_cs.dist, phps, phpt, phtml)
PHP/Pascal                 (inc)
Pig Latin                  (pig)
PL/I                       (pl1)
PL/M                       (lit, plm)
PlantUML                   (puml)
PO File                    (po)
PowerBuilder               (pbt, sra, srf, srm, srs, sru, srw)
PowerShell                 (ps1, psd1, psm1)
ProGuard                   (pro)
Prolog                     (P, prolog, yap, pl, p6, pro)
Properties                 (properties)
Protocol Buffers           (proto)
Pug                        (jade, pug)
PureScript                 (purs)
Python                     (buck, build.bazel, gclient, gyp, gypi, lmi, py, py3, pyde, pyi, pyp, pyt, pyw, sconscript, sconstruct, snakefile, tac, workspace, wscript, wsgi, xpy)
QML                        (qbs, qml)
Qt                         (ui)
Qt Linguist                (ts)
Qt Project                 (pro)
R                          (expr-dist, R, r, rd, rprofile, rsx)
Racket                     (rkt, rktd, rktl, scrbl)
Raku                       (pm6, raku, rakumod)
Raku/Prolog                (P6, p6)
RAML                       (raml)
RapydScript                (pyj)
Razor                      (cshtml, razor)
ReasonML                   (re, rei)
ReScript                   (res, resi)
reStructuredText           (rest, rest.txt, rst, rst.txt)
Rexx                       (pprx, rexx)
Ring                       (rform, rh, ring)
Rmd                        (Rmd)
RobotFramework             (robot)
Ruby                       (appraisals, berksfile, brewfile, builder, buildfile, capfile, dangerfile, deliverfile, eye, fastfile, gemfile, gemfile.lock, gemspec, god, guardfile, irbrc, jarfile, jbuilder, mavenfile, mspec, podfile, podspec, pryrc, puppetfile, rabl, rake, rb, rbuild, rbw, rbx, ru, snapfile, thor, thorfile, vagrantfile, watchr)
Ruby HTML                  (rhtml)
Rust                       (rs, rs.in)
SaltStack                  (sls)
SAS                        (sas)
Sass                       (sass)
Scala                      (kojo, sbt, scala)
Scheme                     (sc, sch, scm, sld, sps, ss, sls)
SCSS                       (scss)
sed                        (sed)
SKILL                      (il)
SKILL++                    (ils)
Slice                      (ice)
Slim                       (slim)
Smalltalk                  (st, cs)
Smarty                     (smarty, tpl)
Softbridge Basic           (SBL, sbl)
Solidity                   (sol)
SparForte                  (sp)
Specman e                  (e)
SQL                        (cql, mysql, psql, SQL, sql, tab, udf, viw)
SQL Data                   (data.sql)
SQL Stored Procedure       (spc.sql, spoc.sql, sproc.sql, udf.sql)
Squirrel                   (nut)
Standard ML                (fun, sig, sml)
Starlark                   (bazel, bzl)
Stata                      (ado, DO, do, doh, ihlp, mata, matah, sthlp)
Stylus                     (styl)
SugarSS                    (sss)
Svelte                     (svelte)
SVG                        (SVG, svg)
Swift                      (swift)
SWIG                       (i)
TableGen                   (td)
Tcl/Tk                     (itk, tcl, tk)
Teamcenter met             (met)
Teamcenter mth             (mth)
TeX                        (aux, bbx, bib, bst, cbx, dtx, ins, lbx, ltx, mkii, mkiv, mkvi, sty, tex, cls)
Text                       (text, txt)
Thrift                     (thrift)
TITAN Project File Information (tpd)
Titanium Style Sheet       (tss)
TNSDL                      (cii, cin, in1, in2, in3, in4, inf, interface, rou, sdl, sdt, spd, ssc, sst)
TOML                       (toml)
tspeg                      (jspeg, tspeg)
TTCN                       (ttcn, ttcn2, ttcn3, ttcnpp)
Twig                       (twig)
TypeScript                 (tsx, ts)
Umka                       (um)
Unity-Prefab               (mat, prefab)
Vala                       (vala)
Vala Header                (vapi)
VB for Applications        (VBA, vba)
Velocity Template Language (vm)
Verilog-SystemVerilog      (sv, svh, v)
VHDL                       (VHD, vhd, VHDL, vhdl, vhf, vhi, vho, vhs, vht, vhw)
vim script                 (vim)
Visual Basic               (BAS, bas, ctl, dsr, frm, FRX, frx, VBHTML, vbhtml, vbp, vbw, cls)
Visual Basic .NET          (VB, vb, vbproj)
Visual Basic Script        (VBS, vbs)
Visual Fox Pro             (SCA, sca)
Visual Studio Module       (ixx)
Visual Studio Solution     (sln)
Visualforce Component      (component)
Visualforce Page           (page)
Vuejs Component            (vue)
Web Services Description   (wsdl)
WebAssembly                (wast, wat)
Windows Message File       (mc)
Windows Module Definition  (def)
Windows Resource File      (rc, rc2)
WiX include                (wxi)
WiX source                 (wxs)
WiX string localization    (wxl)
WXML                       (wxml)
WXSS                       (wxss)
X++                        (xpo)
XAML                       (xaml)
xBase                      (prg, prw)
xBase Header               (ch)
XHTML                      (xhtml)
XMI                        (XMI, xmi)
XML                        (adml, admx, ant, app.config, axml, builds, ccproj, ccxml, classpath, clixml, cproject, cscfg, csdef, csl, ct, depproj, ditamap, ditaval, dll.config, dotsettings, filters, fsproj, gmx, grxml, iml, ivy, jelly, jsproj, kml, launch, mdpolicy, mjml, natvis, ndproj, nproj, nuget.config, nuspec, odd, osm, packages.config, pkgproj, plist, proj, project, props, ps1xml, psc1, pt, rdf, resx, rss, scxml, settings.stylecop, sfproj, shproj, srdf, storyboard, sttheme, sublime-snippet, targets, tmcommand, tml, tmlanguage, tmpreferences, tmsnippet, tmtheme, urdf, ux, vcxproj, vsixmanifest, vssettings, vstemplate, vxml, web.config, web.debug.config, web.release.config, wsf, x3d, xacro, xib, xlf, xliff, XML, xml, xml.dist, xproj, xspec, xul, zcml)
XQuery                     (xq, xql, xqm, xquery, xqy)
XSD                        (XSD, xsd)
XSLT                       (XSL, xsl, XSLT, xslt)
Xtend                      (xtend)
yacc                       (y, yacc)
YAML                       (clang-format, clang-tidy, gemrc, glide.lock, mir, reek, rviz, sublime-syntax, syntax, yaml, yaml-tmlanguage, yml, yml.mysql)
Zig                        (zig)
zsh                        (zsh)
</pre>
