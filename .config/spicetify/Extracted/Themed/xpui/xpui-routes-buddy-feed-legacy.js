"use strict";(("undefined"!=typeof self?self:global).webpackChunkclient_web=("undefined"!=typeof self?self:global).webpackChunkclient_web||[]).push([[6548],{18547:(e,s,i)=>{i.r(s),i.d(s,{default:()=>Se});var a=i(30758),t=i(98466),r=i(64721),n=i(20618),l=i(6128),c=i(61214),d=i(97500),u=i.n(d),o=i(38364);const m="CvWRWfWfmS9_2fgM7c3A",x="gtJcoAXGeGQ9ochIvg6h",h="diF001PSbmYyyekikwD9",j="R_Dc8rJShBX3HCHsoSsq",f="dAPXjNmPLJI6x_sXJwAp",g="cRB7yMdTUrWxDud8Uqvi",p="RTHphmJ9fFJyJWFe9Kwt",N="cm9IUdJYVsbGCooedALf",y="SN5MVM1k5tAxwKeA7WDr",v="Bpdhrb_he3jzWLv40DpE",b="rV7v8LWgSCAQH6wodc1N",S="fD6FfGUH4oiEHvaEXITg",I="egK4lu76sYvMmma40Vng",P="RItf9PObrjsfieRog2Jj",k="j1tGXZDi8vflz1A_NWQU",w="Qv8skgTQdi726aBDU7h1",R="oiz3mGNiTftvX5tHHGdT",T="jaX1TSMeWI3kuiSaau2B",_="dk6yb9gfDFu9V6rM1BdS",D="mABzBE2Irar9vYpZdr9u",L="Ipv3_ecgOssTDK4Z4uYg",U="TkNHSTmRSrRuhd5EpRQg",A="ZV8pEC8PUrYmlL0YmteP",B="V9CrlOWUnPzlcVRfUjy7",E="Pvf7VacWGW22R2cyG3RZ";var G=i(86070);const W=({showOnlineIndicator:e})=>(0,G.jsxs)("div",{className:T,children:[(0,G.jsxs)("div",{className:_,children:[(0,G.jsx)(o.v,{size:"medium"}),e?(0,G.jsx)("div",{className:D}):null]}),(0,G.jsxs)("div",{className:L,children:[(0,G.jsx)("div",{className:u()(U,A)}),(0,G.jsx)("div",{className:U}),(0,G.jsx)("div",{className:U})]})]}),C=()=>(0,G.jsxs)("div",{"data-testid":"buddy-feed-empty-state",className:w,children:[(0,G.jsx)(l.E,{as:"p",className:R,children:r.Ru.get("buddy-feed.let-followers-see-your-listening")}),(0,G.jsx)(W,{showOnlineIndicator:!0}),(0,G.jsx)(W,{showOnlineIndicator:!0}),(0,G.jsx)(W,{}),(0,G.jsx)(l.E,{as:"p",className:R,children:r.Ru.get("buddy-feed.enable-share-listening-activity")}),(0,G.jsx)(n.N_,{to:"/preferences",className:B,children:(0,G.jsx)(c.$,{colorSet:"invertedLight",className:E,children:r.Ru.get("desktop.settings.settings")})})]});var Q=i(68832),F=i(75627),H=i(57682),Y=i(13377),Z=i(58681),O=i(13728),M=i(3602),V=i(1467),J=i(17221),z=i(39557),X=i(55285),K=i(42163),$=i(27303),q=i(43494),ee=i(48750);const se=e=>{const{timestamp:s,isNowPlaying:i}=e;return i?(0,G.jsx)(q.Zp,{label:r.Ru.get("time.now"),children:(0,G.jsx)($.A,{"aria-label":r.Ru.get("time.now"),size:"small"})}):(0,G.jsx)("span",{children:(0,ee.Z)(s)})};var ie=i(92057),ae=i(89494),te=i(977),re=i(95309),ne=i(88417),le=i(11716),ce=i(24902);const de=e=>Date.now()-e<9e5,ue=(e,s)=>{const i=(0,F.o_h)(e)?.type;switch(i){case F.NQG.PLAYLIST:case F.NQG.PLAYLIST_V2:return(0,G.jsx)(M.W,{uri:e});case F.NQG.EPISODE:case F.NQG.SHOW:return(0,G.jsx)(V.H,{uri:e});case F.NQG.ALBUM:return(0,G.jsx)(Z.h,{uri:e,artistUri:s});case F.NQG.ARTIST:return(0,G.jsx)(O.t,{uri:e});default:return null}},oe=e=>{switch(e){case F.NQG.ALBUM:return ce.c.ALBUM;case F.NQG.ARTIST:return ce.c.ARTIST;case F.NQG.SHOW:return ce.c.SHOW;case F.NQG.EPISODE:return ce.c.EPISODE;case F.NQG.PLAYLIST:case F.NQG.PLAYLIST_V2:return ce.c.PLAYLIST;default:return}},me=e=>{const{show:s=!0,spec:i,friend:t}=e,n=(0,a.useMemo)((()=>t.user.imageUrl?[{url:t.user.imageUrl,width:0,height:0}]:[]),[t.user.imageUrl]),c=(0,ae.W)(),d=(0,le.s)(),o=t.track,x=o.uri,{togglePlay:h,isPlaying:j,isActive:w}=(0,ne.P)({uri:x},{featureIdentifier:"buddy_feed",referrerIdentifier:"buddy_feed"}),R=(0,F.o_h)(o.context?.uri),T=R?.type,_=(0,a.useCallback)((()=>{h(),c({intent:j?"pause":"play",type:"click",itemIdSuffix:"buddyfeed_play",targetUri:x});const e=i.friendRowFactory().playButtonFactory();w?j?d.logInteraction(e.hitPause({itemToBePaused:x})):d.logInteraction(e.hitResume({itemToBeResumed:x})):d.logInteraction(e.hitPlay({itemToBePlayed:x}))}),[c,j,x,i,w,h,d]),D=(0,a.useCallback)(((e,s)=>{d.logInteraction(i.friendRowFactory().friendRowLinkFactory({identifier:e}).hitUiNavigate({destination:s}))}),[d,i]),{draggable:L,onDragStart:U}=(0,ie.P)({itemUris:[x],dragLabelText:o.name}),{draggable:A,onDragStart:B}=(0,ie.P)({itemUris:[o.artist?.uri],dragLabelText:o.artist?.name}),{draggable:E,onDragStart:W}=(0,ie.P)({itemUris:[o.context?.uri],dragLabelText:o.context?.name});return s?(0,G.jsxs)("div",{className:u()(m),children:[(0,G.jsx)(Y.h,{menu:ue(o.context?.uri,o.artist?.uri),children:(0,G.jsxs)("div",{className:f,children:[(0,G.jsx)(H.e,{label:t.user.name,width:40,userIconSize:"small",images:n,withBadge:de(t.timestamp)}),(0,G.jsx)(K.x,{className:g,iconClassName:p,isPlaying:j,isLocked:!1,onClick:_,playAriaLabel:j?r.Ru.get("pause"):`${r.Ru.get("play")} ${o.artist.name} ${o.name}`})]})}),(0,G.jsxs)("div",{className:u()(N),children:[(0,G.jsxs)("div",{className:y,children:[(0,G.jsx)(l.E,{as:"p",variant:"bodySmallBold",className:u()(v,"ellipsis-one-line"),children:(0,G.jsx)(re.pZ,{value:"/buddyfeed_user_profile",children:(0,G.jsx)(Y.h,{menu:(0,G.jsx)(z.B,{uri:t.user.uri}),children:(0,G.jsx)(X.N,{title:t.user.name,to:t.user.uri,dir:"auto",onClick:()=>D("profile_link",t.user.uri),children:t.user.name})})})}),(0,G.jsx)(l.E,{as:"p",variant:"marginal",className:u()(b),children:(0,G.jsx)(se,{timestamp:t.timestamp,isNowPlaying:de(t.timestamp)})})]}),(0,G.jsxs)(l.E,{as:"p",variant:"marginal",className:S,children:[(0,G.jsx)(re.pZ,{value:"/buddyfeed_track",children:(0,G.jsx)(Y.h,{menu:(0,G.jsx)(J.P,{uri:o.uri,contextUri:o.context?.uri,albumUri:o.album?.uri,artists:[o.artist]}),children:(0,G.jsx)(X.N,{title:o.name,to:x,className:"ellipsis-one-line",dir:"auto",draggable:L,onDragStart:U,onClick:()=>D("track_link",x),children:o.name})})}),(0,G.jsx)("span",{"aria-hidden":!0,children:" • "}),(0,G.jsx)(re.pZ,{value:"/buddyfeed_artist",children:(0,G.jsx)(Y.h,{menu:o.artist?(0,G.jsx)(O.t,{uri:o.artist.uri}):null,children:(0,G.jsx)(X.N,{title:o.artist?.name,to:o.artist?.uri,className:"ellipsis-one-line",dir:"auto",draggable:A,onDragStart:B,onClick:()=>D("artist_link",o.artist?.uri),children:o.artist?.name})})})]}),(0,G.jsx)(l.E,{as:"p",variant:"marginal",className:u()("ellipsis-one-line",P),children:(0,G.jsx)(re.pZ,{value:"/buddyfeed_context",children:(0,G.jsx)(Y.h,{menu:ue(o.context?.uri,o.artist?.uri),children:(0,G.jsxs)(X.N,{title:o.context?.name,to:o.context?.uri,className:k,draggable:E,onDragStart:W,onClick:()=>D("context_link",o.context?.uri),children:[(0,G.jsx)(te.s,{type:oe(T),iconSize:16,className:I}),(0,G.jsx)("span",{dir:"auto",className:"ellipsis-one-line",children:o.context?.name})]})})})})]})]},t.user.uri):null};var xe=i(65260),he=i(29093),je=i(4316);function fe({friends:e,spec:s}){const{currentSession:i}=(0,je.D)(),t=(0,he.y)(),[r,n]=(0,a.useState)(!0),l=!i?.active&&t&&r&&(0,G.jsx)("li",{className:h,children:(0,G.jsx)(xe.p,{localStorageKey:"dismissStartJamButtonFromFriendFeed",onDismiss:()=>n(!1)})},"start-jam-button");return(0,G.jsx)(Q.ZI,{flipKey:e.map((e=>e.user.uri)).join(""),children:(0,G.jsxs)("ul",{className:x,children:[l,e.map(((e,i)=>(0,G.jsx)(Q.lf,{flipId:e.user.uri,children:(0,G.jsx)("li",{children:(0,G.jsx)(me,{friend:e,show:i<100,spec:s},e.user.uri)})},e.user.uri)))]})})}var ge=i(68376),pe=i(73857),Ne=i(78550),ye=i(2799),ve=i(65234),be=i(1620);const Se=({friends:e})=>{const s=(0,ae.W)(),i=(0,le.s)(),{spec:n}=(0,be.r)(t.W,{}),l=(0,a.useRef)(null);(0,a.useEffect)((()=>{s({intent:"view",type:"impression",itemIdSuffix:"buddyfeed"})}),[s]),(0,a.useEffect)((()=>{i.logImpression(n.impression())}),[i,n]);const c=0===e.length,d=(0,a.useCallback)((()=>{i.logInteraction(n.closeButtonFactory().hitUiHide())}),[i,n]);return(0,G.jsx)(ve.ql.Provider,{value:"buddy_feed",children:(0,G.jsx)(ge._,{label:r.Ru.get("buddy-feed.friend-activity"),focusTransferId:"BUDDY-FEED",children:(0,G.jsx)("div",{className:j,ref:l,children:(0,G.jsx)(pe.w,{fixedHeader:(0,G.jsx)(Ne.a,{title:r.Ru.get("buddy-feed.friend-activity"),panel:ye.Z.BuddyFeed,onClose:d}),children:c?(0,G.jsx)(C,{}):(0,G.jsx)(fe,{friends:e,spec:n})})})})})}}}]);
//# sourceMappingURL=xpui-routes-buddy-feed-legacy.js.map