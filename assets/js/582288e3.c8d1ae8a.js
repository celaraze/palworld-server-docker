"use strict";(self.webpackChunkdocusaurus=self.webpackChunkdocusaurus||[]).push([[356],{6380:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>c,contentTitle:()=>i,default:()=>u,frontMatter:()=>l,metadata:()=>o,toc:()=>a});var r=t(7624),s=t(2172);const l={sidebar_position:2},i="Kubernetes",o={id:"advanced/kubernetes",title:"Kubernetes",description:"All files you will need to deploy this container to kubernetes are located in the k8s folder.",source:"@site/docs/advanced/kubernetes.md",sourceDirName:"advanced",slug:"/advanced/kubernetes",permalink:"/advanced/kubernetes",draft:!1,unlisted:!1,editUrl:"https://github.com/thijsvanloef/palworld-server-docker/tree/main/docusaurus/docs/advanced/kubernetes.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Palworld Directory",permalink:"/advanced/palworld-directory"},next:{title:"Versions",permalink:"/versions/"}},c={},a=[{value:"Setup Palworld in kubernetes",id:"setup-palworld-in-kubernetes",level:2},{value:"Using helm chart",id:"using-helm-chart",level:2}];function d(e){const n={a:"a",code:"code",h1:"h1",h2:"h2",li:"li",p:"p",ul:"ul",...(0,s.M)(),...e.components};return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(n.h1,{id:"kubernetes",children:"Kubernetes"}),"\n",(0,r.jsxs)(n.p,{children:["All files you will need to deploy this container to kubernetes are located in the ",(0,r.jsx)(n.a,{href:"https://github.com/thijsvanloef/palworld-server-docker/tree/main/k8s",children:"k8s folder"}),"."]}),"\n",(0,r.jsx)(n.h2,{id:"setup-palworld-in-kubernetes",children:"Setup Palworld in kubernetes"}),"\n",(0,r.jsx)(n.p,{children:"Use the following commands to setup this Palworld container in Kubernetes:"}),"\n",(0,r.jsxs)(n.ul,{children:["\n",(0,r.jsx)(n.li,{children:(0,r.jsx)(n.code,{children:"kubectl apply -f pvc.yaml"})}),"\n",(0,r.jsx)(n.li,{children:(0,r.jsx)(n.code,{children:"kubectl apply -f configmap.yaml"})}),"\n",(0,r.jsx)(n.li,{children:(0,r.jsx)(n.code,{children:"kubectl apply -f secret.yaml"})}),"\n",(0,r.jsx)(n.li,{children:(0,r.jsx)(n.code,{children:"kubectl apply -f service.yaml"})}),"\n",(0,r.jsx)(n.li,{children:(0,r.jsx)(n.code,{children:"kubectl apply -f deployment.yaml"})}),"\n"]}),"\n",(0,r.jsx)(n.h2,{id:"using-helm-chart",children:"Using helm chart"}),"\n",(0,r.jsxs)(n.p,{children:["The official helm chart can be found in a seperate repository, ",(0,r.jsx)(n.a,{href:"https://github.com/Twinki14/palworld-server-chart",children:"palworld-server-chart"})]})]})}function u(e={}){const{wrapper:n}={...(0,s.M)(),...e.components};return n?(0,r.jsx)(n,{...e,children:(0,r.jsx)(d,{...e})}):d(e)}},2172:(e,n,t)=>{t.d(n,{I:()=>o,M:()=>i});var r=t(1504);const s={},l=r.createContext(s);function i(e){const n=r.useContext(l);return r.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:i(e.components),r.createElement(l.Provider,{value:n},e.children)}}}]);