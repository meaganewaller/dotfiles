"use strict";(("undefined"!=typeof self?self:global).webpackChunkclient_web=("undefined"!=typeof self?self:global).webpackChunkclient_web||[]).push([[987],{89327:(e,s,i)=>{i.d(s,{ParticipantListPage:()=>S});var a=i(30758),t=i(95440),n=i(1978),o=i(6128),r=i(75627),l=i(64721),c=i(26308),m=i(18212),u=i(55847),p=i(62114),d=i(4316),b=i(86070);const g=({memberToBeRemoved:e,onClose:s})=>{const{logRemoveClick:i}=(0,p.R)(),{currentSession:t,removeSessionMember:n}=(0,d.D)(),o=e?.id??"",r=e?.displayName??"",c=t?.sessionId??"",m=(0,a.useCallback)((()=>{i(o,c),o&&(n(o),s())}),[i,o,c,n,s]),g=(0,a.useCallback)((()=>{s()}),[s]);return(0,b.jsx)(u.T,{isOpen:Boolean(o),titleText:l.Ru.get("web-player.social-connect.participant-list.remove-guest-dialog",{displayName:r}),"aria-label":l.Ru.get("web-player.social-connect.participant-list.remove-guest-dialog",{displayName:r}),confirmText:l.Ru.get("web-player.social-connect.participant-list.remove-guest"),cancelText:l.Ru.get("web-player.social-connect.participant-list.remove-guest-cancel"),onConfirm:m,onClose:g})};var h=i(29004),x=i(60858),v=i(10088),y=i(57682),C=i(13377),R=i(39557),w=i(55285),k=i(12344);const j="VaoPVkde4AzxorQnp6Jp",I="dDz8CzVKiV2128rhR543",N="tBAiRbWhD79Gi2XqZ_AG",f=({sessionMember:e,index:s,showRemoveButton:i,onClickRemove:a,onClickMember:t})=>{const{displayName:n,images:r,uri:c,username:m}=(0,k.c)(e);return(0,b.jsx)(C.h,{menu:(0,b.jsx)(R.B,{uri:c}),children:(0,b.jsx)("span",{children:(0,b.jsxs)(v.$,{rowIndex:s,className:j,children:[(0,b.jsx)(x.T,{columnIndex:0,children:(0,b.jsxs)(w.N,{to:c,className:N,onClick:t,"aria-label":n,children:[(0,b.jsx)(y.e,{images:r,userIconSize:"medium",width:32,displayName:n,username:m,label:n}),(0,b.jsx)(o.E,{as:"p",variant:"bodyMediumBold",semanticColor:"textBase",children:n})]})}),i&&(0,b.jsx)(x.T,{columnIndex:1,className:I,children:(0,b.jsx)(h.n,{size:"small",onClick:a,"aria-label":l.Ru.get("web-player.social-connect.participant-list.remove-guest-accessible-label",{displayName:n}),children:l.Ru.get("web-player.social-connect.participant-list.remove-guest")})})]})})})};var B=i(14998);const M="qAE8wMAxO5THZoNqlb0q",S=()=>{const e=(0,t.d4)((e=>e.session.user?.id)),{currentSession:s}=(0,d.D)(),[i,u]=(0,a.useState)(),{logUserClick:p,logRemoveClick:h,UBIFragmentWithSpec:x}=(0,B.T)(),v=(0,a.useCallback)(((e,s)=>{h(e),u(s)}),[h]),y=(0,a.useCallback)(((e,s)=>{const i=(0,r.Qjr)(s.username).toURI();p(e,i)}),[p]),C=(0,a.useCallback)((()=>{u(void 0)}),[]),R=s?.sessionMembers.find((e=>e.id===s.sessionOwnerId));if(!s||!R)return(0,b.jsx)(n.C5,{to:"/queue"});const w=s.isSessionOwner?2:1;return(0,b.jsxs)("section",{className:"contentSpacing",children:[(0,b.jsx)(m.Q,{children:l.Ru.get("web-player.social-connect.participant-list.title",{host:R.displayName})}),(0,b.jsx)(o.E,{as:"h1",variant:"titleSmall",semanticColor:"textBase",children:l.Ru.get("web-player.social-connect.participant-list.title")}),(0,b.jsx)(o.E,{as:"h2",variant:"bodyMediumBold",semanticColor:"textSubdued",children:l.Ru.get("web-player.social-connect.participant-list.subtitle")}),(0,b.jsx)(c.f,{"aria-colcount":w,"aria-rowcount":s.sessionMembers.length,"aria-label":l.Ru.get("web-player.social-connect.participant-list.title"),className:M,children:s.sessionMembers.map(((i,a)=>(0,b.jsx)(f,{sessionMember:i,showRemoveButton:s.isSessionOwner&&i.username!==e,index:a,onClickRemove:()=>v(a,i),onClickMember:()=>y(a,i)},i.displayName)))}),(0,b.jsx)(x,{children:(0,b.jsx)(g,{memberToBeRemoved:i,onClose:C})})]})}},14998:(e,s,i)=>{i.d(s,{T:()=>r});var a=i(30758),t=i(90168),n=i(1620),o=i(86070);const r=()=>{const{spec:e,logger:s,UBIFragment:i}=(0,n.r)(t.I,{});return{logUserClick:(0,a.useCallback)(((i,a)=>{s.logInteraction(e.participantListFactory().participantListRowFactory({position:i}).userLinkFactory().hitUiNavigate({destination:a}))}),[s,e]),logRemoveClick:(0,a.useCallback)((i=>{s.logInteraction(e.participantListFactory().participantListRowFactory({position:i}).removeButtonFactory().hitUiReveal())}),[s,e]),UBIFragmentWithSpec:(0,a.useCallback)((s=>(0,o.jsx)(i,{spec:e,...s})),[i,e])}}},12344:(e,s,i)=>{i.d(s,{c:()=>n,t:()=>o});var a=i(75627);const t=e=>({url:e}),n=e=>{const s=[];return e.largeImageUrl?s.push(t(e.largeImageUrl)):e.imageUrl&&s.push(t(e.imageUrl)),{displayName:e.displayName,images:s,username:e.username,uri:(0,a.Qjr)(e.username).toURI()}},o=(e,s,i)=>{const a=[],t=e.sessionMembers.find((({id:s})=>s===e.sessionOwnerId));t&&a.push(t);const o=e.isSessionOwner?void 0:e?.sessionMembers.find((({username:e})=>e===s));o&&(i?.userFirst?a.unshift(o):a.push(o));const r=e.sessionMembers.filter((({username:i,id:a})=>a!==e.sessionOwnerId&&i!==s));return[...a,...r].map(n)}},62114:(e,s,i)=>{i.d(s,{R:()=>o});var a=i(30758),t=i(95416),n=i(1620);const o=()=>{const{spec:e,logger:s}=(0,n.r)(t.T,{});return{logRemoveClick:(0,a.useCallback)(((i,a)=>{s.logInteraction(e.buttonRowFactory().removeButtonFactory().hitRemoveParticipant({participantId:i,sessionId:a}))}),[s,e])}}}}]);
//# sourceMappingURL=dwp-participant-list-page.js.map