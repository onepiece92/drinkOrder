import { useState, useEffect, useCallback, useRef } from "react";

const P = [
  {id:1,name:"Macallan 25 Year Sherry Oak",sub:"Single Malt Scotch Whisky",region:"Speyside, Scotland",price:1899,vol:"750ml",abv:"43%",age:"25",rate:4.8,type:"Single Malt Scotch",cat:"Whiskey",col:"#6b3a1f",acc:"#c9a55c",desc:"A masterpiece from The Macallan\u2019s legendary sherry-seasoned oak casks. Twenty-five years of patient maturation yields extraordinary depth.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Dried fruits, orange peel, wood smoke"},{i:"\ud83d\udc45",l:"Palate",d:"Rich toffee, dark chocolate, ginger spice"},{i:"\u2728",l:"Finish",d:"Extraordinarily long, dried fruits and sweet oak"}]},
  {id:2,name:"Bruichladdich Octomore 14.1",sub:"Super Heavily Peated Scotch",region:"Islay, Scotland",price:199,vol:"750ml",abv:"57.2%",age:"5",rate:4.6,type:"Islay Single Malt",cat:"Scotch",col:"#2a3525",acc:"#8faa7c",desc:"The world\u2019s most heavily peated whisky yet astonishingly nuanced.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Intense peat smoke, lemon zest"},{i:"\ud83d\udc45",l:"Palate",d:"Smoky sweetness, charred oak"},{i:"\u2728",l:"Finish",d:"Long smoky, lingering citrus"}]},
  {id:3,name:"Hibiki 21 Year",sub:"Japanese Blended Whisky",region:"Osaka, Japan",price:1299,vol:"750ml",abv:"43%",age:"21",rate:4.9,type:"Japanese Blend",cat:"Whiskey",col:"#4a3020",acc:"#d4a574",desc:"Over twenty whiskies aged twenty-one years including rare Mizunara oak.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Sandalwood, dried apricot"},{i:"\ud83d\udc45",l:"Palate",d:"Lychee, rose water, dark honey"},{i:"\u2728",l:"Finish",d:"Endless Japanese oak, sweet fruit"}]},
  {id:4,name:"Louis XIII Cognac",sub:"Grande Champagne Cognac",region:"Cognac, France",price:4200,vol:"700ml",abv:"40%",age:"100+",rate:5.0,type:"Cognac",cat:"Cognac",col:"#5a2a15",acc:"#e8c070",desc:"Up to 1,200 eaux-de-vie aged 40 to 100 years. A time capsule.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Myrrh, honey, dried roses"},{i:"\ud83d\udc45",l:"Palate",d:"Saffron, fig, ginger"},{i:"\u2728",l:"Finish",d:"Over an hour of evolving flavors"}]},
  {id:5,name:"Yamazaki 18 Year",sub:"Single Malt Japanese Whisky",region:"Osaka, Japan",price:699,vol:"750ml",abv:"43%",age:"18",rate:4.7,type:"Japanese Single Malt",cat:"Whiskey",col:"#402820",acc:"#c8956a",desc:"Japan\u2019s first malt whisky distillery creates fruity complexity.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Blackberry jam, dark chocolate"},{i:"\ud83d\udc45",l:"Palate",d:"Dried mango, cocoa, cinnamon"},{i:"\u2728",l:"Finish",d:"Long, sweet, lingering incense"}]},
  {id:6,name:"Ardbeg An Oa",sub:"Islay Single Malt",region:"Islay, Scotland",price:85,vol:"750ml",abv:"46.6%",age:"NAS",rate:4.5,type:"Islay Single Malt",cat:"Scotch",col:"#1f2a30",acc:"#6fa8b8",desc:"Named after the windswept Mull of Oa on Islay.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Toffee, aniseed, smoky chocolate"},{i:"\ud83d\udc45",l:"Palate",d:"Orange cream, smoked banana"},{i:"\u2728",l:"Finish",d:"Sweet, full-bodied, charcoal"}]},
  {id:7,name:"The Dalmore 12",sub:"Highland Single Malt",region:"Highlands, Scotland",price:64.99,vol:"750ml",abv:"40%",age:"12",rate:4.3,type:"Highland Scotch",cat:"Scotch",col:"#5a2a20",acc:"#b87a50",badge:"Great Value",desc:"Aged in American white oak then finished in oloroso sherry casks.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Citrus marmalade, vanilla"},{i:"\ud83d\udc45",l:"Palate",d:"Orange, chocolate, cinnamon"},{i:"\u2728",l:"Finish",d:"Long and lingering warmth"}]},
  {id:8,name:"Buffalo Trace",sub:"Kentucky Straight Bourbon",region:"Kentucky, USA",price:29.99,vol:"750ml",abv:"45%",age:"NAS",rate:4.2,type:"Kentucky Bourbon",cat:"Bourbon",col:"#4a3018",acc:"#c49a60",badge:"Staff Pick",desc:"The finest corn, rye, and barley malt in new charred oak.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Vanilla, caramel, toffee"},{i:"\ud83d\udc45",l:"Palate",d:"Brown sugar, oak, dark fruit"},{i:"\u2728",l:"Finish",d:"Long, smooth, sweet toffee"}]},
  {id:9,name:"Monkey Shoulder",sub:"Blended Malt Scotch",region:"Speyside, Scotland",price:34.99,vol:"750ml",abv:"40%",age:"NAS",rate:4.1,type:"Blended Malt",cat:"Scotch",col:"#3a3020",acc:"#a89060",badge:"Best Seller",desc:"Three Speyside single malts. Smooth, rich, mixable.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Zesty orange, vanilla, honey"},{i:"\ud83d\udc45",l:"Palate",d:"Mellow vanilla, spiced honey"},{i:"\u2728",l:"Finish",d:"Clean, mellow, lingering"}]},
  {id:10,name:"Redbreast 12",sub:"Single Pot Still Irish",region:"Midleton, Ireland",price:69.99,vol:"750ml",abv:"40%",age:"12",rate:4.5,type:"Irish Pot Still",cat:"Whiskey",col:"#5a2828",acc:"#c07050",badge:"Award Winner",desc:"Quintessential Irish Pot Still whiskey.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Sherry nuttiness, dried fruits"},{i:"\ud83d\udc45",l:"Palate",d:"Creamy toffee, green apple"},{i:"\u2728",l:"Finish",d:"Long pot still spice"}]},
  {id:11,name:"Don Julio 1942",sub:"Anejo Tequila",region:"Jalisco, Mexico",price:169,vol:"750ml",abv:"40%",age:"2.5",rate:4.6,type:"Anejo Tequila",cat:"Tequila",col:"#4a3a18",acc:"#d4a040",desc:"Handcrafted small batches, aged two and a half years.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Caramel, chocolate, warm oak"},{i:"\ud83d\udc45",l:"Palate",d:"Vanilla, toasted agave"},{i:"\u2728",l:"Finish",d:"Warm, lingering oak"}]},
  {id:12,name:"Diplomatico Reserva",sub:"Venezuelan Rum",region:"Venezuela",price:39.99,vol:"750ml",abv:"40%",age:"12",rate:4.4,type:"Venezuelan Rum",cat:"Rum",col:"#3a2218",acc:"#c48a50",desc:"Smooth rum blend aged up to twelve years.",taste:[{i:"\ud83d\udc43",l:"Nose",d:"Rum cake, brown sugar"},{i:"\ud83d\udc45",l:"Palate",d:"Rich caramel, dark chocolate"},{i:"\u2728",l:"Finish",d:"Long, sweet, lingering spice"}]},
];

const CATS = ["All","Whiskey","Bourbon","Scotch","Cognac","Tequila","Rum"];
const sf = "'Playfair Display',Georgia,serif";
const sf2 = "'Cormorant Garamond',Georgia,serif";
const G = "#c9a55c", GL = "#e4c780", GD = "#a07d3a", BG = "#111", CD = "#1e1e1e";
const TX = "#f5f0e8", T2 = "#9a9590", T3 = "#6b6560", BR = "rgba(201,165,92,.12)";

const fmt = (n) => n >= 1000 ? "$" + n.toLocaleString() : n % 1 ? "$" + n.toFixed(2) : "$" + n;

const doFilter = (cat, q, sort) => {
  let r = [...P];
  if (cat && cat !== "All") r = r.filter(x => x.cat === cat);
  if (q) { const s = q.toLowerCase(); r = r.filter(x => x.name.toLowerCase().includes(s) || x.type.toLowerCase().includes(s)); }
  if (sort === "pa") r.sort((a,b) => a.price - b.price);
  else if (sort === "pd") r.sort((a,b) => b.price - a.price);
  else if (sort === "r") r.sort((a,b) => b.rate - a.rate);
  else if (sort === "n") r.sort((a,b) => a.name.localeCompare(b.name));
  return r;
};

const Bot = ({w,h,c,a,l1="",l2=""}) => {
  const sw=w*.28,sh=h*.11,bw=w*.4,nw=w*.2,uid="b"+w+l1.replace(/\W/g,"");
  return (
    <svg viewBox={`0 0 ${w} ${h}`} fill="none" width={w} height={h}>
      <defs><linearGradient id={uid} x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor={c}/><stop offset="50%" stopColor={c} stopOpacity=".8"/><stop offset="100%" stopColor={c}/></linearGradient></defs>
      <rect x={(w-sw)/2} y={h*.01} width={sw} height={sh} rx={sw*.15} fill={c} stroke={a} strokeWidth=".5"/>
      <rect x={(w-nw)/2} y={h*.01+sh} width={nw} height={h*.03} rx="2" fill={a} opacity=".6"/>
      <path d={`M${(w-nw)/2} ${h*.01+sh+h*.03}L${(w-bw)/2} ${h*.25}L${(w-bw)/2} ${h*.92}Q${(w-bw)/2} ${h*.99} ${w/2} ${h*.99}Q${(w+bw)/2} ${h*.99} ${(w+bw)/2} ${h*.92}L${(w+bw)/2} ${h*.25}L${(w+nw)/2} ${h*.01+sh+h*.03}`} fill={`url(#${uid})`} stroke={a} strokeWidth=".5"/>
      <rect x={(w-bw*.85)/2} y={h*.35} width={bw*.85} height={h*.3} rx="2" fill="rgba(201,165,92,.08)" stroke={a} strokeWidth=".3"/>
      <text x={w/2} y={h*.47} fontFamily="serif" fontSize={w*.08} fill={a} textAnchor="middle" fontWeight="600">{l1}</text>
      <text x={w/2} y={h*.55} fontFamily="serif" fontSize={w*.06} fill={a} textAnchor="middle" opacity=".7">{l2}</text>
    </svg>
  );
};

const HB = ({children, badge, onClick}) => (
  <div onClick={onClick} style={{width:42,height:42,borderRadius:"50%",background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer",position:"relative"}}>
    {children}
    {badge > 0 && <span style={{position:"absolute",top:-2,right:-2,minWidth:16,height:16,background:G,borderRadius:8,fontSize:9,fontWeight:700,color:"#111",display:"flex",alignItems:"center",justifyContent:"center",padding:"0 4px"}}>{badge > 9 ? "9+" : badge}</span>}
  </div>
);

const AB = ({sz=32, onClick}) => (
  <button onClick={e => {e.stopPropagation(); onClick();}} style={{width:sz,height:sz,borderRadius:10,background:`linear-gradient(135deg,${G},${GD})`,border:"none",display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}>
    <svg viewBox="0 0 24 24" style={{width:14,height:14,stroke:"#111",fill:"none",strokeWidth:2.5}}><path d="M12 5v14"/><path d="M5 12h14"/></svg>
  </button>
);

const QC = ({v, onI, onD, sm}) => {
  const sz = sm ? 28 : 36;
  return (
    <div style={{display:"flex",alignItems:"center",background:CD,borderRadius:sm?8:12,border:`1px solid ${BR}`}}>
      <button onClick={onD} style={{width:sz,height:sz,border:"none",background:"transparent",display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:12,height:12,stroke:T2,fill:"none",strokeWidth:2}}><path d="M5 12h14"/></svg></button>
      <span style={{fontSize:sm?13:16,fontWeight:600,color:TX,minWidth:sm?20:28,textAlign:"center"}}>{v}</span>
      <button onClick={onI} style={{width:sz,height:sz,border:"none",background:"transparent",display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:12,height:12,stroke:G,fill:"none",strokeWidth:2}}><path d="M12 5v14"/><path d="M5 12h14"/></svg></button>
    </div>
  );
};

const HeartIcon = ({filled, sz=14, clr=T3}) => filled
  ? <svg viewBox="0 0 24 24" style={{width:sz,height:sz}}><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z" fill={G} stroke={G} strokeWidth="1.5"/></svg>
  : <svg viewBox="0 0 24 24" style={{width:sz,height:sz,stroke:clr,fill:"none",strokeWidth:1.5}}><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>;

const Card = ({p, wide, onSel, onAdd, isW, onW}) => (
  <div onClick={() => onSel(p)} style={{background:CD,border:`1px solid ${BR}`,borderRadius:wide?20:18,padding:wide?16:14,cursor:"pointer",position:"relative",overflow:"hidden",flex:wide?"0 0 170px":undefined,scrollSnapAlign:wide?"start":undefined}}>
    <div onClick={e => {e.stopPropagation(); onW(p);}} style={{position:"absolute",top:12,right:12,zIndex:5,cursor:"pointer"}}><HeartIcon filled={isW}/></div>
    {p.badge && <span style={{position:"absolute",top:14,left:14,background:"rgba(74,180,120,.15)",color:"#4ab478",fontSize:10,fontWeight:500,padding:"4px 10px",borderRadius:8,zIndex:2}}>{p.badge}</span>}
    <div style={{width:"100%",height:wide?140:110,display:"flex",alignItems:"center",justifyContent:"center",marginBottom:wide?14:12,position:"relative"}}>
      <Bot w={wide?40:32} h={wide?120:100} c={p.col} a={p.acc} l1={p.name.split(" ")[0]} l2={p.age+"yr"}/>

    </div>
    <div style={{fontFamily:sf,fontSize:wide?14:13,fontWeight:500,lineHeight:1.3,marginBottom:4,overflow:"hidden",display:"-webkit-box",WebkitLineClamp:2,WebkitBoxOrient:"vertical",color:TX}}>{p.name}</div>
    <div style={{fontSize:11,color:T3,fontWeight:300,marginBottom:wide?12:10}}>{p.type}</div>
    <div style={{display:"flex",justifyContent:"space-between",alignItems:"center"}}><span style={{fontFamily:sf,fontSize:wide?16:15,fontWeight:500,color:GL}}>{fmt(p.price)}</span><AB sz={wide?32:28} onClick={() => onAdd(p)}/></div>
  </div>
);

const CartDraw = ({cart, open, onClose, onQty, onRm, onCO}) => {
  const tot = cart.reduce((s,i) => s+i.price*i.qty, 0);
  const cnt = cart.reduce((s,i) => s+i.qty, 0);
  return (
    <>
      <div onClick={onClose} style={{position:"absolute",inset:0,background:"rgba(0,0,0,.6)",zIndex:300,opacity:open?1:0,pointerEvents:open?"all":"none",transition:"opacity .3s"}}/>
      <div style={{position:"absolute",bottom:0,left:0,width:"100%",maxHeight:"80%",background:BG,borderRadius:"28px 28px 0 0",border:`1px solid ${BR}`,borderBottom:"none",zIndex:301,transform:open?"translateY(0)":"translateY(100%)",transition:"transform .4s cubic-bezier(.22,1,.36,1)",display:"flex",flexDirection:"column"}}>
        <div style={{display:"flex",justifyContent:"center",padding:"12px 0 4px"}}><div style={{width:36,height:4,borderRadius:2,background:"rgba(201,165,92,.25)"}}/></div>
        <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"8px 24px 16px"}}>
          <div><div style={{fontFamily:sf,fontSize:22,fontWeight:500,color:TX}}>Your Cart</div><div style={{fontSize:12,color:T3,marginTop:2}}>{cnt} {cnt===1?"item":"items"}</div></div>
          <div onClick={onClose} style={{width:36,height:36,borderRadius:"50%",background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:T2,fill:"none",strokeWidth:1.5}}><path d="M18 6L6 18"/><path d="M6 6l12 12"/></svg></div>
        </div>
        <div style={{flex:1,overflowY:"auto",padding:"0 24px"}}>
          {cart.length === 0
            ? <div style={{textAlign:"center",padding:"48px 0",color:T3}}><div style={{fontSize:40,marginBottom:12,opacity:.4}}>🥃</div><div style={{fontFamily:sf,fontSize:18,color:T2,marginBottom:6}}>Nothing here yet</div><div style={{fontSize:13}}>Add some rare spirits</div></div>
            : cart.map(it => (
              <div key={it.id} style={{display:"flex",gap:14,padding:"16px 0",borderBottom:`1px solid ${BR}`,alignItems:"center"}}>
                <div style={{width:56,height:72,borderRadius:12,background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}><Bot w={20} h={60} c={it.col||"#2a2520"} a={it.acc||GD}/></div>
                <div style={{flex:1,minWidth:0}}>
                  <div style={{fontFamily:sf,fontSize:14,fontWeight:500,overflow:"hidden",textOverflow:"ellipsis",whiteSpace:"nowrap",color:TX}}>{it.name}</div>
                  <div style={{fontSize:11,color:T3,marginTop:2}}>{it.vol}</div>
                  <div style={{display:"flex",alignItems:"center",gap:12,marginTop:8}}>
                    <QC sm v={it.qty} onI={() => onQty(it.id,1)} onD={() => onQty(it.id,-1)}/>
                    <button onClick={() => onRm(it.id)} style={{background:"transparent",border:"none",cursor:"pointer",padding:4}}><svg viewBox="0 0 24 24" style={{width:14,height:14,stroke:T3,fill:"none",strokeWidth:1.5}}><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/></svg></button>
                  </div>
                </div>
                <div style={{fontFamily:sf,fontSize:15,fontWeight:500,color:GL,flexShrink:0}}>{fmt(it.price*it.qty)}</div>
              </div>
            ))}
        </div>
        {cart.length > 0 && <div style={{padding:"16px 24px 32px",borderTop:`1px solid ${BR}`}}><div style={{display:"flex",justifyContent:"space-between",marginBottom:16}}><span style={{fontSize:13,color:T2}}>Subtotal</span><span className="shim" style={{fontFamily:sf,fontSize:22,fontWeight:600}}>{fmt(tot)}</span></div><button onClick={onCO} style={{width:"100%",padding:18,background:`linear-gradient(135deg,${G},${GD})`,border:"none",borderRadius:16,color:"#111",fontSize:15,fontWeight:600,letterSpacing:1,textTransform:"uppercase",cursor:"pointer"}}>Checkout</button></div>}
      </div>
    </>
  );
};

const Detail = ({p, onBack, onAdd, onToast, wl, onWish}) => {
  const [qty, setQty] = useState(1);
  useEffect(() => setQty(1), [p?.id]);
  if (!p) return null;
  const inW = wl.some(w => w.id === p.id);
  return (
    <>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"12px 24px 8px",position:"sticky",top:0,zIndex:50,background:`linear-gradient(to bottom,${BG} 60%,transparent)`}}>
        <div onClick={onBack} style={{width:42,height:42,borderRadius:"50%",background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:18,height:18,stroke:TX,fill:"none",strokeWidth:1.5}}><path d="M19 12H5"/><path d="M12 19l-7-7 7-7"/></svg></div>
        <div style={{display:"flex",gap:10}}>
          <HB onClick={() => {onWish(p); onToast(inW?"Removed":"Saved to wishlist");}}><HeartIcon filled={inW} sz={18} clr={G}/></HB>
          <HB><svg viewBox="0 0 24 24" style={{width:18,height:18,stroke:G,fill:"none",strokeWidth:1.5}}><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><path d="M8.59 13.51l6.83 3.98"/><path d="M15.41 6.51l-6.82 3.98"/></svg></HB>
        </div>
      </div>
      <div style={{width:"100%",height:320,display:"flex",alignItems:"center",justifyContent:"center",position:"relative",marginBottom:8}}>
        <div style={{position:"absolute",width:200,height:200,borderRadius:"50%",background:"radial-gradient(circle,rgba(201,165,92,.1),transparent 70%)",filter:"blur(40px)"}}/>
        <div className="float-bot" style={{position:"relative",zIndex:2,filter:"drop-shadow(0 20px 50px rgba(0,0,0,.5))"}}><Bot w={90} h={270} c={p.col} a={p.acc} l1={p.name.split(" ")[0]} l2={p.age+" Yr"}/></div>
      </div>
      <div style={{padding:"0 24px"}}>
        <div style={{fontSize:11,letterSpacing:2.5,textTransform:"uppercase",color:G,marginBottom:10,display:"flex",alignItems:"center",gap:10}}><span style={{width:24,height:1,background:G,display:"inline-block"}}/>{p.region}</div>
        <div style={{fontFamily:sf,fontSize:28,fontWeight:600,lineHeight:1.15,marginBottom:8,color:TX}}>{p.name}</div>
        <div style={{fontFamily:sf2,fontSize:17,fontWeight:300,fontStyle:"italic",color:T2,marginBottom:20}}>{p.sub}</div>
        <div style={{display:"flex",marginBottom:28,background:CD,border:`1px solid ${BR}`,borderRadius:18,padding:"16px 0"}}>
          {[{v:p.age,l:"Years"},{v:p.abv,l:"ABV"},{v:p.vol.replace("ml",""),l:"ml"},{v:p.rate,l:"Rating"}].map((s,i,a) => (
            <div key={s.l} style={{flex:1,textAlign:"center",borderRight:i<a.length-1?`1px solid ${BR}`:"none"}}><div style={{fontFamily:sf,fontSize:18,fontWeight:600,marginBottom:4,color:TX}}>{s.v}</div><div style={{fontSize:10,color:T3,letterSpacing:1,textTransform:"uppercase"}}>{s.l}</div></div>
          ))}
        </div>
        <div style={{marginBottom:28}}>
          <div style={{fontFamily:sf,fontSize:18,fontWeight:500,marginBottom:16,color:TX}}>Tasting Notes</div>
          {p.taste.map(t => (
            <div key={t.l} style={{display:"flex",alignItems:"flex-start",gap:14,marginBottom:14}}>
              <div style={{width:40,height:40,borderRadius:12,background:"rgba(201,165,92,.15)",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0,fontSize:18}}>{t.i}</div>
              <div><div style={{fontSize:12,color:T3,letterSpacing:1,textTransform:"uppercase",marginBottom:3}}>{t.l}</div><div style={{fontFamily:sf2,fontSize:15,color:T2,lineHeight:1.4}}>{t.d}</div></div>
            </div>
          ))}
        </div>
        <div style={{marginBottom:28}}><div style={{fontFamily:sf,fontSize:18,fontWeight:500,marginBottom:16,color:TX}}>About</div><p style={{fontFamily:sf2,fontSize:15,fontWeight:300,color:T2,lineHeight:1.7,margin:0}}>{p.desc}</p></div>
      </div>
      <div style={{padding:"0 24px 36px",marginBottom:80}}>
        <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",marginBottom:16}}>
          <div><div style={{fontSize:10,color:T3,letterSpacing:1,textTransform:"uppercase",marginBottom:2}}>Price</div><div className="shim" style={{fontFamily:sf,fontSize:26,fontWeight:600}}>{fmt(p.price*qty)}</div></div>
          <div><div style={{fontSize:10,color:T3,letterSpacing:1,textTransform:"uppercase",marginBottom:6,textAlign:"center"}}>Quantity</div><QC v={qty} onI={() => setQty(q=>q+1)} onD={() => setQty(q=>Math.max(1,q-1))}/></div>
        </div>
        <button onClick={() => {onAdd(p,qty); onToast(qty+"x "+p.name.split(" ").slice(0,2).join(" ")+" added");}} style={{width:"100%",padding:18,background:`linear-gradient(135deg,${G},${GD})`,border:"none",borderRadius:16,color:"#111",fontSize:15,fontWeight:600,letterSpacing:1,textTransform:"uppercase",cursor:"pointer",display:"flex",alignItems:"center",justifyContent:"center",gap:10}}>
          <svg viewBox="0 0 24 24" style={{width:18,height:18,stroke:"#111",fill:"none",strokeWidth:2}}><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 002 1.61h9.72a2 2 0 002-1.61L23 6H6"/></svg>Add to Cart
        </button>
      </div>
    </>
  );
};

const Wish = ({list, onBack, onSel, onTog, onAdd}) => (
  <>
    <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"12px 24px 8px",position:"sticky",top:0,zIndex:50,background:`linear-gradient(to bottom,${BG} 60%,transparent)`}}>
      <div onClick={onBack} style={{width:42,height:42,borderRadius:"50%",background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:18,height:18,stroke:TX,fill:"none",strokeWidth:1.5}}><path d="M19 12H5"/><path d="M12 19l-7-7 7-7"/></svg></div>
      <div style={{fontFamily:sf,fontSize:18,fontWeight:500,color:TX}}>Wishlist</div>
      <div style={{width:42}}/>
    </div>
    <div style={{padding:"16px 24px 120px"}}>
      {list.length === 0
        ? <div style={{textAlign:"center",padding:"80px 0",color:T3}}><HeartIcon sz={48} clr="rgba(201,165,92,.25)"/><div style={{fontFamily:sf,fontSize:20,color:T2,margin:"16px 0 8px"}}>Your wishlist is empty</div><div style={{fontSize:13}}>Tap the heart to save spirits</div></div>
        : list.map(pr => (
          <div key={pr.id} onClick={() => onSel(pr)} style={{display:"flex",gap:14,padding:"16px 0",borderBottom:`1px solid ${BR}`,alignItems:"center",cursor:"pointer"}}>
            <div style={{width:60,height:80,borderRadius:14,background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}><Bot w={24} h={68} c={pr.col} a={pr.acc}/></div>
            <div style={{flex:1,minWidth:0}}><div style={{fontFamily:sf,fontSize:15,fontWeight:500,marginBottom:3,color:TX}}>{pr.name}</div><div style={{fontSize:12,color:T3,marginBottom:8}}>{pr.type} · {pr.vol}</div><div style={{fontFamily:sf,fontSize:16,color:GL}}>{fmt(pr.price)}</div></div>
            <div style={{display:"flex",flexDirection:"column",gap:8,alignItems:"center"}}><div onClick={e => {e.stopPropagation(); onTog(pr);}} style={{cursor:"pointer"}}><HeartIcon filled sz={20}/></div><AB sz={28} onClick={() => onAdd(pr)}/></div>
          </div>
        ))}
    </div>
  </>
);

const SLIDER_BG = [
  "linear-gradient(135deg,#1a1510,#2a2015,#1a1510)",
  "linear-gradient(135deg,#101a15,#152a20,#101a15)",
  "linear-gradient(135deg,#15101a,#201520,#15101a)",
  "linear-gradient(135deg,#1a1015,#2a1520,#1a1015)",
];

const EditorSlider = ({picks, onSel}) => {
  const [idx, setIdx] = useState(0);
  const [touchX, setTouchX] = useState(null);
  const timerRef = useRef(null);

  useEffect(() => {
    timerRef.current = setInterval(() => setIdx(i => (i+1) % picks.length), 4500);
    return () => clearInterval(timerRef.current);
  }, [picks.length]);

  const go = (n) => { clearInterval(timerRef.current); setIdx(n); timerRef.current = setInterval(() => setIdx(i => (i+1) % picks.length), 4500); };
  const onTS = (e) => setTouchX(e.touches[0].clientX);
  const onTE = (e) => { if (touchX===null) return; const dx = e.changedTouches[0].clientX - touchX; if (Math.abs(dx)>40) { go(dx>0 ? (idx-1+picks.length)%picks.length : (idx+1)%picks.length); } setTouchX(null); };

  const p = picks[idx];
  return (
    <div className="fade-up d1" style={{margin:"0 24px 28px",position:"relative"}}>
      <div onClick={() => onSel(p)} onTouchStart={onTS} onTouchEnd={onTE}
        style={{borderRadius:24,overflow:"hidden",position:"relative",height:190,background:SLIDER_BG[idx%SLIDER_BG.length],border:`1px solid ${BR}`,cursor:"pointer",transition:"background .6s ease"}}>
        <div style={{position:"absolute",inset:0,background:"radial-gradient(circle at 75% 50%,rgba(201,165,92,.12),transparent 60%)"}}/>
        <div key={p.id} style={{position:"relative",zIndex:2,padding:28,height:"100%",display:"flex",flexDirection:"column",justifyContent:"space-between",animation:"fadeUp .5s ease both"}}>
          <div style={{display:"flex",alignItems:"center",gap:8}}>
            <span style={{width:18,height:1,background:G,display:"inline-block"}}/>
            <span style={{fontSize:10,fontWeight:500,letterSpacing:2.5,textTransform:"uppercase",color:G}}>Editor's Pick</span>
          </div>
          <div style={{fontFamily:sf,fontSize:22,fontWeight:600,lineHeight:1.2,maxWidth:"55%",color:TX}}>{p.name}</div>
          <div style={{display:"flex",alignItems:"center",gap:16}}>
            <span className="shim" style={{fontFamily:sf,fontSize:20,fontWeight:500}}>{fmt(p.price)}</span>
            <span style={{fontSize:12,color:T3}}>{p.vol} · {p.abv}</span>
          </div>
        </div>
        <div key={p.id+"bot"} style={{position:"absolute",right:10,bottom:-10,zIndex:3,filter:"drop-shadow(0 10px 30px rgba(0,0,0,.5))",transition:"opacity .4s",animation:"fadeUp .5s ease both"}}>
          <Bot w={55} h={180} c={p.col} a={p.acc} l1={p.name.split(" ")[0].toUpperCase()} l2={p.age+" YR"}/>
        </div>
      </div>
      <div style={{display:"flex",justifyContent:"center",gap:6,marginTop:12}}>
        {picks.map((_, i) => (
          <div key={i} onClick={() => go(i)} style={{width:idx===i?20:6,height:6,borderRadius:3,background:idx===i?G:"rgba(201,165,92,.25)",transition:"all .3s cubic-bezier(.22,1,.36,1)",cursor:"pointer"}}/>
        ))}
      </div>
    </div>
  );
};

const Home = ({onSel, onAdd, cc, onCart, wl, onWish}) => {
  const [cat, setCat] = useState("All");
  const [sort, setSort] = useState("feat");
  const [q, setQ] = useState("");
  const [showS, setShowS] = useState(false);
  const [fl, setFl] = useState(P);
  const isF = q || cat !== "All" || sort !== "feat";
  const wm = {};
  wl.forEach(w => { wm[w.id] = true; });
  const ft = P.slice(0, 6);
  const vp = P.filter(x => x.badge);
  useEffect(() => { const t = setTimeout(() => setFl(doFilter(cat, q, sort)), q ? 250 : 0); return () => clearTimeout(t); }, [cat, q, sort]);

  const gis = {width:18,height:18,stroke:G,fill:"none",strokeWidth:1.5};
  return (
    <>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"12px 24px 8px",position:"sticky",top:0,zIndex:50,background:`linear-gradient(to bottom,${BG} 60%,transparent)`}}>
        <span style={{fontWeight:600,fontSize:14,color:TX}}>9:41</span><div/>
      </div>
      <div style={{padding:"8px 24px 20px",display:"flex",justifyContent:"space-between",alignItems:"flex-start"}}>
        <div>
          <div style={{fontWeight:300,fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:4}}>Deliver to</div>
          <div style={{display:"flex",alignItems:"center",gap:6}}><svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:G,fill:"none",strokeWidth:1.5}}><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg><span style={{fontSize:15,fontWeight:500,color:TX}}>Kathmandu</span></div>
        </div>
        <div style={{display:"flex",gap:12,paddingTop:6}}>
          <HB badge={2}><svg viewBox="0 0 24 24" style={gis}><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg></HB>
          <HB badge={cc} onClick={onCart}><svg viewBox="0 0 24 24" style={gis}><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 002 1.61h9.72a2 2 0 002-1.61L23 6H6"/></svg></HB>
        </div>
      </div>
      <div style={{margin:"0 24px 20px",position:"relative"}}>
        <svg viewBox="0 0 24 24" style={{position:"absolute",left:18,top:"50%",transform:"translateY(-50%)",width:18,height:18,stroke:T3,fill:"none",strokeWidth:1.5}}><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
        <input value={q} onChange={e => setQ(e.target.value)} placeholder="Search rare spirits..." style={{width:"100%",padding:"14px 20px 14px 48px",background:CD,border:`1px solid ${BR}`,borderRadius:16,color:TX,fontSize:14,fontWeight:300,outline:"none",fontFamily:"inherit"}}/>
        {q && <div onClick={() => setQ("")} style={{position:"absolute",right:14,top:"50%",transform:"translateY(-50%)",cursor:"pointer",padding:4}}><svg viewBox="0 0 24 24" style={{width:14,height:14,stroke:T3,fill:"none",strokeWidth:2}}><path d="M18 6L6 18"/><path d="M6 6l12 12"/></svg></div>}
      </div>
      <div style={{display:"flex",gap:8,padding:"0 24px 16px",overflowX:"auto"}}>
        {CATS.map(c => <div key={c} onClick={() => setCat(c)} style={{padding:"10px 20px",borderRadius:30,whiteSpace:"nowrap",cursor:"pointer",fontSize:13,fontWeight:cat===c?500:400,background:cat===c?`linear-gradient(135deg,${G},${GD})`:CD,border:cat===c?"1px solid transparent":`1px solid ${BR}`,color:cat===c?"#111":T2}}>{c}</div>)}
      </div>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"0 24px 16px"}}>
        <div style={{fontSize:12,color:T3}}>{fl.length} spirits</div>
        <div style={{position:"relative"}}>
          <div onClick={() => setShowS(!showS)} style={{display:"flex",alignItems:"center",gap:6,cursor:"pointer",padding:"6px 12px",background:CD,border:`1px solid ${BR}`,borderRadius:10}}><svg viewBox="0 0 24 24" style={{width:14,height:14,stroke:G,fill:"none",strokeWidth:1.5}}><path d="M3 6h18M6 12h12M9 18h6"/></svg><span style={{fontSize:12,color:T2}}>Sort</span></div>
          {showS && <div style={{position:"absolute",right:0,top:"100%",marginTop:8,background:CD,border:`1px solid ${BR}`,borderRadius:14,padding:6,zIndex:60,minWidth:150,boxShadow:"0 12px 40px rgba(0,0,0,.5)"}}>
            {[{k:"feat",l:"Featured"},{k:"pa",l:"Price Low"},{k:"pd",l:"Price High"},{k:"r",l:"Top Rated"},{k:"n",l:"A-Z"}].map(s => <div key={s.k} onClick={() => {setSort(s.k); setShowS(false);}} style={{padding:"10px 14px",borderRadius:10,fontSize:13,color:sort===s.k?G:T2,background:sort===s.k?"rgba(201,165,92,.15)":"transparent",cursor:"pointer"}}>{s.l}</div>)}
          </div>}
        </div>
      </div>
      {isF ? (
        <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:14,padding:"0 24px 120px"}}>
          {fl.length === 0 ? <div style={{gridColumn:"1/-1",textAlign:"center",padding:"60px 0",color:T3}}><div style={{fontSize:32,marginBottom:12,opacity:.4}}>🔍</div><div style={{fontSize:18,color:T2}}>No spirits found</div></div> : fl.map(pr => <Card key={pr.id} p={pr} onSel={onSel} onAdd={onAdd} isW={!!wm[pr.id]} onW={onWish}/>)}
        </div>
      ) : (
        <>
          <EditorSlider picks={ft.slice(0,4)} onSel={onSel}/>

          <div style={{display:"flex",justifyContent:"space-between",alignItems:"baseline",padding:"0 24px 16px"}}><div style={{fontFamily:sf,fontSize:20,fontWeight:500,color:TX}}>Rare Allocations</div><span onClick={() => {setCat("All"); setSort("r");}} style={{fontSize:12,color:G,letterSpacing:1,textTransform:"uppercase",cursor:"pointer"}}>View All</span></div>
          <div style={{paddingBottom:28}}><div style={{display:"flex",gap:16,padding:"0 24px",overflowX:"auto",scrollSnapType:"x mandatory"}}>{ft.map(pr => <Card key={pr.id} p={pr} wide onSel={onSel} onAdd={onAdd} isW={!!wm[pr.id]} onW={onWish}/>)}</div></div>
          <div style={{display:"flex",justifyContent:"space-between",alignItems:"baseline",padding:"0 24px 16px"}}><div style={{fontFamily:sf,fontSize:20,fontWeight:500,color:TX}}>Best in Price</div><span onClick={() => {setCat("All"); setSort("pa");}} style={{fontSize:12,color:G,letterSpacing:1,textTransform:"uppercase",cursor:"pointer"}}>View All</span></div>
          <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:14,padding:"0 24px 120px"}}>{vp.map(pr => <Card key={pr.id} p={pr} onSel={onSel} onAdd={onAdd} isW={!!wm[pr.id]} onW={onWish}/>)}</div>
        </>
      )}
    </>
  );
};

const Nav = ({act, onChange, cc, wc}) => {
  const tabs = [
    {k:"home",l:"Home",paths:["M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z","M9 22V12h6v10"]},
    {k:"cart",l:"Cart",paths:["M1 1h4l2.68 13.39a2 2 0 002 1.61h9.72a2 2 0 002-1.61L23 6H6"],circles:[{cx:9,cy:21,r:1},{cx:20,cy:21,r:1}],b:cc},
    {k:"wish",l:"Wishlist",paths:["M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"],b:wc},
    {k:"prof",l:"Profile",paths:["M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"],circles:[{cx:12,cy:7,r:4}]}
  ];
  return (
    <div style={{position:"absolute",bottom:0,left:0,width:"100%",padding:"12px 24px 28px",display:"flex",justifyContent:"space-around",alignItems:"center",background:`linear-gradient(to top,${BG} 70%,transparent)`,zIndex:100}}>
      {tabs.map(t => {
        const a = act === t.k;
        return (
          <div key={t.k} onClick={() => onChange(t.k)} style={{display:"flex",flexDirection:"column",alignItems:"center",gap:4,cursor:"pointer",padding:"6px 12px"}}>
            <div style={{position:"relative"}}>
              <svg viewBox="0 0 24 24" style={{width:22,height:22,stroke:a?G:T3,fill:"none",strokeWidth:1.5}}>
                {t.paths.map((d,i) => <path key={i} d={d}/>)}
                {t.circles && t.circles.map((c,i) => <circle key={i} cx={c.cx} cy={c.cy} r={c.r}/>)}
              </svg>
              {t.b > 0 && <span style={{position:"absolute",top:-6,right:-10,minWidth:16,height:16,background:G,borderRadius:8,fontSize:9,fontWeight:700,color:"#111",display:"flex",alignItems:"center",justifyContent:"center",padding:"0 4px"}}>{t.b>9?"9+":t.b}</span>}
            </div>
            <span style={{fontSize:10,color:a?G:T3}}>{t.l}</span>
            {a && <div style={{width:4,height:4,borderRadius:"50%",background:G,marginTop:2,boxShadow:"0 0 8px rgba(201,165,92,.5)"}}/>}
          </div>
        );
      })}
    </div>
  );
};

const SubHeader = ({title, onBack}) => (
  <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"12px 24px 8px",position:"sticky",top:0,zIndex:50,background:`linear-gradient(to bottom,${BG} 60%,transparent)`}}>
    <div onClick={onBack} style={{width:42,height:42,borderRadius:"50%",background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:18,height:18,stroke:TX,fill:"none",strokeWidth:1.5}}><path d="M19 12H5"/><path d="M12 19l-7-7 7-7"/></svg></div>
    <div style={{fontFamily:sf,fontSize:18,fontWeight:500,color:TX}}>{title}</div>
    <div style={{width:42}}/>
  </div>
);

const Field = ({label, value, ph}) => (
  <div style={{marginBottom:16}}>
    <div style={{fontSize:11,color:T3,letterSpacing:1,textTransform:"uppercase",marginBottom:6}}>{label}</div>
    <div style={{padding:"14px 16px",background:CD,border:`1px solid ${BR}`,borderRadius:12,color:value?TX:T3,fontSize:14}}>{value||ph||"Not set"}</div>
  </div>
);

const Toggle = ({label, desc, on, onTap}) => (
  <div onClick={onTap} style={{display:"flex",alignItems:"center",justifyContent:"space-between",padding:"16px 0",borderBottom:`1px solid ${BR}`,cursor:"pointer"}}>
    <div><div style={{fontSize:14,fontWeight:500,color:TX}}>{label}</div>{desc && <div style={{fontSize:12,color:T3,marginTop:2}}>{desc}</div>}</div>
    <div style={{width:44,height:26,borderRadius:13,background:on?G:"#333",padding:2,transition:"background .3s",display:"flex",alignItems:on?"center":"center",justifyContent:on?"flex-end":"flex-start"}}><div style={{width:22,height:22,borderRadius:11,background:on?"#111":"#666",transition:"all .3s"}}/></div>
  </div>
);

const PgPersonal = ({onBack}) => (
  <><SubHeader title="Personal Info" onBack={onBack}/>
  <div style={{padding:"24px",display:"flex",flexDirection:"column",alignItems:"center"}}>
    <div style={{width:80,height:80,borderRadius:"50%",background:`linear-gradient(135deg,${G},${GD})`,display:"flex",alignItems:"center",justifyContent:"center",marginBottom:8,boxShadow:"0 8px 30px rgba(201,165,92,.2)"}}><svg viewBox="0 0 24 24" style={{width:36,height:36,stroke:"#111",fill:"none",strokeWidth:1.5}}><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
    <div style={{fontSize:12,color:G,cursor:"pointer",marginBottom:24}}>Change Photo</div>
  </div>
  <div style={{padding:"0 24px 120px"}}>
    <Field label="Full Name" value="Spirits Connoisseur"/>
    <Field label="Email" value="connoisseur@liquidgold.com"/>
    <Field label="Phone" value="+1 (555) 867-5309"/>
    <Field label="Date of Birth" value="January 15, 1990"/>
    <button style={{width:"100%",padding:16,background:`linear-gradient(135deg,${G},${GD})`,border:"none",borderRadius:14,color:"#111",fontSize:14,fontWeight:600,letterSpacing:1,textTransform:"uppercase",cursor:"pointer",marginTop:8}}>Save Changes</button>
  </div></>
);

const PgAddresses = ({onBack}) => {
  const addrs = [{id:1,label:"Home",addr:"123 Oak Street, Apt 4B",city:"Brooklyn, NY 11201",def:true},{id:2,label:"Office",addr:"456 Park Avenue, Floor 12",city:"Manhattan, NY 10022",def:false}];
  return (<><SubHeader title="Delivery Addresses" onBack={onBack}/>
  <div style={{padding:"16px 24px 120px"}}>
    {addrs.map(a => (
      <div key={a.id} style={{background:CD,border:`1px solid ${a.def?G:BR}`,borderRadius:18,padding:20,marginBottom:14}}>
        <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:10}}>
          <div style={{display:"flex",alignItems:"center",gap:8}}><svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:G,fill:"none",strokeWidth:1.5}}><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg><span style={{fontSize:14,fontWeight:500,color:TX}}>{a.label}</span></div>
          {a.def && <span style={{fontSize:10,background:"rgba(201,165,92,.15)",color:G,padding:"4px 10px",borderRadius:8,fontWeight:500}}>Default</span>}
        </div>
        <div style={{fontSize:13,color:T2,lineHeight:1.5}}>{a.addr}<br/>{a.city}</div>
        <div style={{display:"flex",gap:12,marginTop:14}}>
          <span style={{fontSize:12,color:G,cursor:"pointer"}}>Edit</span>
          {!a.def && <span style={{fontSize:12,color:T3,cursor:"pointer"}}>Set as default</span>}
          {!a.def && <span style={{fontSize:12,color:"#e85d5d",cursor:"pointer"}}>Remove</span>}
        </div>
      </div>
    ))}
    <button style={{width:"100%",padding:16,background:"transparent",border:`1px dashed ${BR}`,borderRadius:14,color:G,fontSize:14,fontWeight:500,cursor:"pointer",display:"flex",alignItems:"center",justifyContent:"center",gap:8,marginTop:8}}>
      <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:G,fill:"none",strokeWidth:2}}><path d="M12 5v14"/><path d="M5 12h14"/></svg>Add New Address
    </button>
  </div></>);
};

const PgPayment = ({onBack}) => {
  const cards = [{id:1,type:"Visa",last4:"4242",exp:"12/28",def:true},{id:2,type:"Mastercard",last4:"8888",exp:"06/27",def:false}];
  return (<><SubHeader title="Payment Methods" onBack={onBack}/>
  <div style={{padding:"16px 24px 120px"}}>
    {cards.map(c => (
      <div key={c.id} style={{background:CD,border:`1px solid ${c.def?G:BR}`,borderRadius:18,padding:20,marginBottom:14}}>
        <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:10}}>
          <div style={{display:"flex",alignItems:"center",gap:10}}>
            <div style={{width:40,height:28,borderRadius:6,background:"rgba(201,165,92,.1)",display:"flex",alignItems:"center",justifyContent:"center",fontSize:10,fontWeight:600,color:G}}>{c.type==="Visa"?"VISA":"MC"}</div>
            <div><div style={{fontSize:14,fontWeight:500,color:TX}}>{c.type} ····{c.last4}</div><div style={{fontSize:11,color:T3,marginTop:2}}>Expires {c.exp}</div></div>
          </div>
          {c.def && <span style={{fontSize:10,background:"rgba(201,165,92,.15)",color:G,padding:"4px 10px",borderRadius:8,fontWeight:500}}>Default</span>}
        </div>
        <div style={{display:"flex",gap:12,marginTop:8}}>
          {!c.def && <span style={{fontSize:12,color:G,cursor:"pointer"}}>Set as default</span>}
          <span style={{fontSize:12,color:"#e85d5d",cursor:"pointer"}}>Remove</span>
        </div>
      </div>
    ))}
    <button style={{width:"100%",padding:16,background:"transparent",border:`1px dashed ${BR}`,borderRadius:14,color:G,fontSize:14,fontWeight:500,cursor:"pointer",display:"flex",alignItems:"center",justifyContent:"center",gap:8,marginTop:8}}>
      <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:G,fill:"none",strokeWidth:2}}><path d="M12 5v14"/><path d="M5 12h14"/></svg>Add New Card
    </button>
  </div></>);
};

const PgNotifications = ({onBack}) => {
  const [n, setN] = useState({push:true,email:true,sms:false,promo:true,price:true,order:true,restock:false});
  const t = (k) => setN(s => ({...s,[k]:!s[k]}));
  return (<><SubHeader title="Notifications" onBack={onBack}/>
  <div style={{padding:"16px 24px 120px"}}>
    <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12}}>Channels</div>
    <Toggle label="Push Notifications" desc="Alerts on your device" on={n.push} onTap={() => t("push")}/>
    <Toggle label="Email" desc="Updates to your inbox" on={n.email} onTap={() => t("email")}/>
    <Toggle label="SMS" desc="Text message alerts" on={n.sms} onTap={() => t("sms")}/>
    <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12,marginTop:28}}>Alerts</div>
    <Toggle label="Promotions & Offers" desc="Exclusive deals and discounts" on={n.promo} onTap={() => t("promo")}/>
    <Toggle label="Price Drops" desc="When wishlist items go on sale" on={n.price} onTap={() => t("price")}/>
    <Toggle label="Order Updates" desc="Shipping and delivery status" on={n.order} onTap={() => t("order")}/>
    <Toggle label="Restock Alerts" desc="When sold-out items return" on={n.restock} onTap={() => t("restock")}/>
  </div></>);
};

const PgSettings = ({onBack}) => {
  const [s, setS] = useState({dark:true,bio:false,loc:true});
  const t = (k) => setS(v => ({...v,[k]:!v[k]}));
  return (<><SubHeader title="Settings" onBack={onBack}/>
  <div style={{padding:"16px 24px 120px"}}>
    <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12}}>Appearance</div>
    <Toggle label="Dark Mode" desc="Always look this good" on={s.dark} onTap={() => t("dark")}/>
    <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12,marginTop:28}}>Security</div>
    <Toggle label="Biometric Login" desc="Face ID / Fingerprint" on={s.bio} onTap={() => t("bio")}/>
    <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",padding:"16px 0",borderBottom:`1px solid ${BR}`,cursor:"pointer"}}>
      <div><div style={{fontSize:14,fontWeight:500,color:TX}}>Change Password</div><div style={{fontSize:12,color:T3,marginTop:2}}>Last changed 30 days ago</div></div>
      <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:T3,fill:"none",strokeWidth:1.5}}><path d="M9 18l6-6-6-6"/></svg>
    </div>
    <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12,marginTop:28}}>Privacy</div>
    <Toggle label="Location Services" desc="For delivery estimates" on={s.loc} onTap={() => t("loc")}/>
    <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",padding:"16px 0",borderBottom:`1px solid ${BR}`,cursor:"pointer"}}>
      <div><div style={{fontSize:14,fontWeight:500,color:TX}}>Privacy Policy</div></div>
      <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:T3,fill:"none",strokeWidth:1.5}}><path d="M9 18l6-6-6-6"/></svg>
    </div>
    <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",padding:"16px 0",borderBottom:`1px solid ${BR}`,cursor:"pointer"}}>
      <div><div style={{fontSize:14,fontWeight:500,color:TX}}>Terms of Service</div></div>
      <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:T3,fill:"none",strokeWidth:1.5}}><path d="M9 18l6-6-6-6"/></svg>
    </div>
    <div style={{marginTop:28,textAlign:"center"}}><span style={{fontSize:12,color:T3}}>Liquid Gold v2.1.0</span></div>
  </div></>);
};

const PgHelp = ({onBack}) => {
  const [openFaq, setOpenFaq] = useState(null);
  const faqs = [
    {q:"How long does delivery take?",a:"Standard delivery takes 3-5 business days. Express delivery is available for next-day in select metro areas. All orders are shipped in temperature-controlled packaging."},
    {q:"What is your return policy?",a:"Unopened bottles may be returned within 30 days for a full refund. Damaged items are replaced at no charge. Contact support with your order number to initiate a return."},
    {q:"Do you ship internationally?",a:"Currently we ship to all 50 US states. International shipping to select countries is coming soon. Join our waitlist for updates."},
    {q:"How do I track my order?",a:"Once shipped, you'll receive a tracking link via email and push notification. You can also check order status in the Orders section of your profile."},
    {q:"Is my payment information secure?",a:"Absolutely. All transactions are encrypted with 256-bit SSL. We never store your full card number and are PCI DSS compliant."},
  ];
  return (<><SubHeader title="Help & Support" onBack={onBack}/>
  <div style={{padding:"16px 24px 120px"}}>
    <div style={{background:CD,border:`1px solid ${BR}`,borderRadius:18,padding:20,marginBottom:24,textAlign:"center"}}>
      <svg viewBox="0 0 24 24" style={{width:32,height:32,stroke:G,fill:"none",strokeWidth:1.5,display:"inline-block",marginBottom:8}}><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
      <div style={{fontFamily:sf,fontSize:16,fontWeight:500,color:TX,marginBottom:4}}>Need Help?</div>
      <div style={{fontSize:12,color:T3,marginBottom:14}}>Our spirits experts are available 24/7</div>
      <button style={{padding:"12px 32px",background:`linear-gradient(135deg,${G},${GD})`,border:"none",borderRadius:12,color:"#111",fontSize:13,fontWeight:600,cursor:"pointer"}}>Start Live Chat</button>
    </div>
    <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:16}}>Frequently Asked</div>
    {faqs.map((f,i) => (
      <div key={i} style={{marginBottom:2}}>
        <div onClick={() => setOpenFaq(openFaq===i?null:i)} style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"14px 0",borderBottom:`1px solid ${BR}`,cursor:"pointer"}}>
          <span style={{fontSize:14,fontWeight:500,color:TX,flex:1}}>{f.q}</span>
          <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:T3,fill:"none",strokeWidth:1.5,transform:openFaq===i?"rotate(180deg)":"rotate(0)",transition:"transform .3s"}}><path d="M6 9l6 6 6-6"/></svg>
        </div>
        {openFaq===i && <div style={{padding:"12px 0 16px",fontSize:13,color:T2,lineHeight:1.6,animation:"fadeUp .3s ease both"}}>{f.a}</div>}
      </div>
    ))}
    <div style={{marginTop:28,display:"flex",gap:12}}>
      <div style={{flex:1,background:CD,border:`1px solid ${BR}`,borderRadius:14,padding:16,textAlign:"center",cursor:"pointer"}}>
        <svg viewBox="0 0 24 24" style={{width:20,height:20,stroke:G,fill:"none",strokeWidth:1.5,display:"inline-block",marginBottom:6}}><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
        <div style={{fontSize:12,color:TX}}>Email Us</div>
      </div>
      <div style={{flex:1,background:CD,border:`1px solid ${BR}`,borderRadius:14,padding:16,textAlign:"center",cursor:"pointer"}}>
        <svg viewBox="0 0 24 24" style={{width:20,height:20,stroke:G,fill:"none",strokeWidth:1.5,display:"inline-block",marginBottom:6}}><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6A19.79 19.79 0 012.12 4.18 2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/></svg>
        <div style={{fontSize:12,color:TX}}>Call Us</div>
      </div>
    </div>
  </div></>);
};

const Profile = ({onBack, cc, wc, orderCount}) => {
  const [pg, setPg] = useState(null);
  const is = {width:18,height:18,stroke:G,fill:"none",strokeWidth:1.5};
  const menuItem = (icon, label, val, key) => (
    <div onClick={() => setPg(key)} style={{display:"flex",alignItems:"center",gap:14,padding:"16px 0",borderBottom:`1px solid ${BR}`,cursor:"pointer"}}>
      <div style={{width:40,height:40,borderRadius:12,background:"rgba(201,165,92,.1)",display:"flex",alignItems:"center",justifyContent:"center",flexShrink:0}}>{icon}</div>
      <div style={{flex:1}}><div style={{fontSize:14,fontWeight:500,color:TX}}>{label}</div></div>
      {val && <span style={{fontSize:13,color:T2,marginRight:4}}>{val}</span>}
      <svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:T3,fill:"none",strokeWidth:1.5}}><path d="M9 18l6-6-6-6"/></svg>
    </div>
  );
  if (pg==="personal") return <PgPersonal onBack={() => setPg(null)}/>;
  if (pg==="addresses") return <PgAddresses onBack={() => setPg(null)}/>;
  if (pg==="payment") return <PgPayment onBack={() => setPg(null)}/>;
  if (pg==="notif") return <PgNotifications onBack={() => setPg(null)}/>;
  if (pg==="settings") return <PgSettings onBack={() => setPg(null)}/>;
  if (pg==="help") return <PgHelp onBack={() => setPg(null)}/>;
  return (
    <>
      <SubHeader title="Profile" onBack={onBack}/>
      <div style={{padding:"24px",display:"flex",flexDirection:"column",alignItems:"center"}}>
        <div style={{width:80,height:80,borderRadius:"50%",background:`linear-gradient(135deg,${G},${GD})`,display:"flex",alignItems:"center",justifyContent:"center",marginBottom:16,boxShadow:"0 8px 30px rgba(201,165,92,.2)"}}>
          <svg viewBox="0 0 24 24" style={{width:36,height:36,stroke:"#111",fill:"none",strokeWidth:1.5}}><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        </div>
        <div style={{fontFamily:sf,fontSize:22,fontWeight:600,color:TX,marginBottom:4}}>Connoisseur</div>
        <div style={{fontSize:13,color:T2,marginBottom:24}}>Premium Member</div>
        <div style={{display:"flex",gap:20,marginBottom:32,width:"100%",justifyContent:"center"}}>
          {[{n:orderCount,l:"Orders"},{n:wc,l:"Wishlist"},{n:cc,l:"In Cart"}].map(s => (
            <div key={s.l} style={{textAlign:"center",flex:1,padding:"16px 0",background:CD,borderRadius:16,border:`1px solid ${BR}`}}>
              <div style={{fontFamily:sf,fontSize:22,fontWeight:600,color:GL,marginBottom:4}}>{s.n}</div>
              <div style={{fontSize:11,color:T3,letterSpacing:1,textTransform:"uppercase"}}>{s.l}</div>
            </div>
          ))}
        </div>
      </div>
      <div style={{padding:"0 24px 120px"}}>
        <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12}}>Account</div>
        {menuItem(<svg viewBox="0 0 24 24" style={is}><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>, "Personal Info", null, "personal")}
        {menuItem(<svg viewBox="0 0 24 24" style={is}><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>, "Delivery Addresses", "2", "addresses")}
        {menuItem(<svg viewBox="0 0 24 24" style={is}><rect x="1" y="4" width="22" height="16" rx="2"/><path d="M1 10h22"/></svg>, "Payment Methods", "1", "payment")}
        <div style={{fontSize:11,color:T3,letterSpacing:1.5,textTransform:"uppercase",marginBottom:12,marginTop:24}}>Preferences</div>
        {menuItem(<svg viewBox="0 0 24 24" style={is}><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg>, "Notifications", null, "notif")}
        {menuItem(<svg viewBox="0 0 24 24" style={is}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>, "Settings", null, "settings")}
        {menuItem(<svg viewBox="0 0 24 24" style={is}><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"/><path d="M12 17h.01"/></svg>, "Help & Support", null, "help")}
        <div style={{marginTop:24,padding:"14px 0",textAlign:"center",cursor:"pointer"}}>
          <span style={{fontSize:14,color:"#e85d5d",fontWeight:500}}>Sign Out</span>
        </div>
      </div>
    </>
  );
};

const Checkout = ({cart, onBack, onDone, onToast}) => {
  const [step, setStep] = useState(0);
  const [processing, setProcessing] = useState(false);
  const [orderId, setOrderId] = useState("");
  const [form, setForm] = useState({name:"",addr:"",city:"",zip:"",card:"",exp:"",cvv:""});
  const tot = cart.reduce((s,i) => s+i.price*i.qty, 0);
  const cnt = cart.reduce((s,i) => s+i.qty, 0);
  const upd = (k,v) => setForm(f => ({...f,[k]:v}));
  const inp = (label,key,ph,type) => (
    <div style={{marginBottom:16}}>
      <div style={{fontSize:11,color:T3,letterSpacing:1,textTransform:"uppercase",marginBottom:6}}>{label}</div>
      <input value={form[key]} onChange={e => upd(key,e.target.value)} placeholder={ph} type={type||"text"} style={{width:"100%",padding:"14px 16px",background:CD,border:`1px solid ${BR}`,borderRadius:12,color:TX,fontSize:14,outline:"none",fontFamily:"inherit"}}/>
    </div>
  );
  const canNext = step===0 ? form.name&&form.addr&&form.city&&form.zip : step===1 ? form.card&&form.exp&&form.cvv : true;
  const doPlace = () => {
    setProcessing(true);
    setTimeout(() => {
      setOrderId("LG-" + Math.random().toString(36).substr(2,8).toUpperCase());
      setStep(3);
      setProcessing(false);
    }, 2000);
  };
  if (step === 3) return (
    <div style={{display:"flex",flexDirection:"column",alignItems:"center",justifyContent:"center",minHeight:"80vh",padding:"0 40px",textAlign:"center"}}>
      <div style={{width:80,height:80,borderRadius:"50%",background:"rgba(74,180,120,.15)",display:"flex",alignItems:"center",justifyContent:"center",marginBottom:24}}><svg viewBox="0 0 24 24" style={{width:40,height:40,stroke:"#4ab478",fill:"none",strokeWidth:2}}><polyline points="20 6 9 17 4 12"/></svg></div>
      <div style={{fontFamily:sf,fontSize:26,fontWeight:600,color:TX,marginBottom:8}}>Order Placed!</div>
      <div style={{fontSize:14,color:T2,marginBottom:6}}>Order #{orderId}</div>
      <div style={{fontSize:13,color:T3,marginBottom:32}}>{cnt} items · {fmt(tot)}</div>
      <button onClick={onDone} style={{padding:"16px 48px",background:`linear-gradient(135deg,${G},${GD})`,border:"none",borderRadius:16,color:"#111",fontSize:15,fontWeight:600,letterSpacing:1,textTransform:"uppercase",cursor:"pointer"}}>Continue Shopping</button>
    </div>
  );
  return (
    <>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",padding:"12px 24px 8px",position:"sticky",top:0,zIndex:50,background:`linear-gradient(to bottom,${BG} 60%,transparent)`}}>
        <div onClick={step>0?() => setStep(s=>s-1):onBack} style={{width:42,height:42,borderRadius:"50%",background:CD,border:`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",cursor:"pointer"}}><svg viewBox="0 0 24 24" style={{width:18,height:18,stroke:TX,fill:"none",strokeWidth:1.5}}><path d="M19 12H5"/><path d="M12 19l-7-7 7-7"/></svg></div>
        <div style={{fontFamily:sf,fontSize:18,fontWeight:500,color:TX}}>Checkout</div>
        <div style={{width:42}}/>
      </div>
      <div style={{display:"flex",gap:8,padding:"16px 24px 24px",justifyContent:"center"}}>
        {["Shipping","Payment","Review"].map((s,i) => (
          <div key={s} style={{display:"flex",alignItems:"center",gap:8}}>
            <div style={{width:28,height:28,borderRadius:"50%",background:i<=step?G:"transparent",border:i<=step?"none":`1px solid ${BR}`,display:"flex",alignItems:"center",justifyContent:"center",fontSize:12,fontWeight:600,color:i<=step?"#111":T3}}>{i<step?"✓":i+1}</div>
            <span style={{fontSize:12,color:i<=step?TX:T3,fontWeight:i===step?500:400}}>{s}</span>
            {i<2 && <div style={{width:20,height:1,background:BR}}/>}
          </div>
        ))}
      </div>
      <div style={{padding:"0 24px 120px"}}>
        {step === 0 && <>{inp("Full Name","name","John Doe")}{inp("Address","addr","123 Main St")}<div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:12}}>{inp("City","city","New York")}{inp("ZIP Code","zip","10001")}</div></>}
        {step === 1 && <>{inp("Card Number","card","4242 4242 4242 4242")}<div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:12}}>{inp("Expiry","exp","12/28")}{inp("CVV","cvv","123","password")}</div><div style={{display:"flex",alignItems:"center",gap:8,padding:"12px 16px",background:CD,borderRadius:12,border:`1px solid ${BR}`,marginTop:8}}><svg viewBox="0 0 24 24" style={{width:16,height:16,stroke:"#4ab478",fill:"none",strokeWidth:1.5}}><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg><span style={{fontSize:12,color:T2}}>Encrypted & secure</span></div></>}
        {step === 2 && <div style={{background:CD,border:`1px solid ${BR}`,borderRadius:18,padding:20}}><div style={{fontFamily:sf,fontSize:16,fontWeight:500,color:TX,marginBottom:16}}>Order Summary</div>{cart.map(it => <div key={it.id} style={{display:"flex",justifyContent:"space-between",padding:"8px 0",borderBottom:`1px solid ${BR}`,fontSize:13}}><span style={{color:T2}}>{it.name} x{it.qty}</span><span style={{color:GL}}>{fmt(it.price*it.qty)}</span></div>)}<div style={{display:"flex",justifyContent:"space-between",padding:"16px 0 0",fontSize:15,fontWeight:600}}><span style={{color:TX}}>Total</span><span style={{fontFamily:sf,color:GL}}>{fmt(tot)}</span></div><div style={{marginTop:16,padding:"12px 16px",background:"rgba(201,165,92,.08)",borderRadius:12}}><div style={{fontSize:12,color:T2}}>{form.name} · {form.addr}, {form.city} {form.zip}</div><div style={{fontSize:12,color:T3,marginTop:4}}>Card ending {form.card.slice(-4)||"****"}</div></div></div>}
        <button disabled={!canNext||processing} onClick={() => step<2?setStep(s=>s+1):doPlace()} style={{width:"100%",padding:18,background:canNext?`linear-gradient(135deg,${G},${GD})`:"#333",border:"none",borderRadius:16,color:canNext?"#111":"#666",fontSize:15,fontWeight:600,letterSpacing:1,textTransform:"uppercase",cursor:canNext?"pointer":"default",marginTop:24,opacity:processing?.6:1}}>
          {processing?"Processing...":step===2?"Place Order":step===1?"Review Order":"Continue"}
        </button>
      </div>
    </>
  );
};

export default function LiquidGoldApp() {
  const [scr, setScr] = useState("home");
  const [sel, setSel] = useState(null);
  const [cart, setCart] = useState([]);
  const [wl, setWl] = useState([]);
  const [cartOpen, setCartOpen] = useState(false);
  const [toast, setToast] = useState({m:"",v:false});
  const [tab, setTab] = useState("home");

  useEffect(() => {
    if (!document.getElementById("lg-fonts")) {
      const link = document.createElement("link");
      link.id = "lg-fonts";
      link.rel = "stylesheet";
      link.href = "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400&family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,300;1,400&family=Outfit:wght@200;300;400;500;600&display=swap";
      document.head.appendChild(link);
    }
  }, []);

  const [orderCount, setOrderCount] = useState(0);

  const cc = cart.reduce((s,i) => s+i.qty, 0);
  const tt = useCallback(m => { setToast({m,v:true}); setTimeout(() => setToast(t => ({...t,v:false})), 2000); }, []);
  const addC = useCallback((p, qty) => { const am = qty||1; setCart(c => { const e = c.find(i => i.id===p.id); return e ? c.map(i => i.id===p.id ? {...i, qty:i.qty+am} : i) : [...c, {...p, qty:am}]; }); if (!qty) tt(p.name.split(" ").slice(0,2).join(" ")+" added"); }, [tt]);
  const updQ = useCallback((id,d) => setCart(c => c.map(i => i.id===id ? {...i, qty:Math.max(1,i.qty+d)} : i)), []);
  const rmC = useCallback(id => setCart(c => c.filter(i => i.id!==id)), []);
  const togW = useCallback(p => setWl(w => w.some(x => x.id===p.id) ? w.filter(x => x.id!==p.id) : [...w, p]), []);
  const goSel = useCallback(p => { setSel(p); setScr("detail"); }, []);
  const goHome = useCallback(() => { setScr("home"); setSel(null); setTab("home"); }, []);
  const goCheckout = useCallback(() => { setCartOpen(false); setScr("checkout"); }, []);
  const orderDone = useCallback(() => { setCart([]); setOrderCount(c => c+1); goHome(); }, [goHome]);
  const doTab = useCallback(t => { if (t==="cart"){setCartOpen(true);return;} if (t==="wish"){setScr("wishlist");setTab("wish");return;} if (t==="prof"){setScr("profile");setTab("prof");return;} if (t==="home") goHome(); setTab(t); }, [goHome]);

  const scrStyle = (n) => {
    const base = {position:"absolute",inset:0,overflowY:"auto",overflowX:"hidden",transition:"transform .4s cubic-bezier(.22,1,.36,1),opacity .4s cubic-bezier(.22,1,.36,1)"};
    if (scr===n) return {...base,transform:"translateX(0)",opacity:1};
    if (n==="home") return {...base,transform:"translateX(-30%)",opacity:0,pointerEvents:"none"};
    return {...base,transform:"translateX(100%)",opacity:0,pointerEvents:"none"};
  };

  return (
    <div style={{width:"100%",maxWidth:430,margin:"0 auto",minHeight:"100vh",position:"relative",overflow:"hidden",background:BG,fontFamily:"'Outfit',sans-serif",color:TX,WebkitFontSmoothing:"antialiased"}}>
      <style>{`
        @keyframes fadeUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
        @keyframes shimmer{0%{background-position:-200% center}100%{background-position:200% center}}
        @keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}
        @keyframes popIn{0%{transform:scale(.5);opacity:0}100%{transform:scale(1);opacity:1}}
        .fade-up{animation:fadeUp .6s cubic-bezier(.22,1,.36,1) both}
        .d1{animation-delay:.1s}.d2{animation-delay:.2s}.d3{animation-delay:.3s}.d4{animation-delay:.4s}
        .shim{background:linear-gradient(90deg,${GD},${GL},${G},${GL},${GD});background-size:200% auto;-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;animation:shimmer 4s ease-in-out infinite}
        .float-bot{animation:float 4s ease-in-out infinite}
        .pop{animation:popIn .3s cubic-bezier(.34,1.56,.64,1)}
      `}</style>
      <div style={scrStyle("home")}><Home onSel={goSel} onAdd={addC} cc={cc} onCart={() => setCartOpen(true)} wl={wl} onWish={togW}/></div>
      <div style={scrStyle("detail")}><Detail p={sel} onBack={goHome} onAdd={addC} onToast={tt} wl={wl} onWish={togW}/></div>
      <div style={scrStyle("wishlist")}><Wish list={wl} onBack={goHome} onSel={goSel} onTog={togW} onAdd={addC}/></div>
      <div style={scrStyle("checkout")}><Checkout cart={cart} onBack={goHome} onDone={orderDone} onToast={tt}/></div>
      <div style={scrStyle("profile")}><Profile onBack={goHome} cc={cc} wc={wl.length} orderCount={orderCount}/></div>
      <CartDraw cart={cart} open={cartOpen} onClose={() => setCartOpen(false)} onQty={updQ} onRm={rmC} onCO={goCheckout}/>
      <div style={{position:"absolute",bottom:100,left:"50%",transform:`translateX(-50%) translateY(${toast.v?0:20}px)`,background:"#252525",border:`1px solid ${BR}`,borderRadius:14,padding:"12px 24px",fontSize:13,color:GL,opacity:toast.v?1:0,transition:"all .4s cubic-bezier(.34,1.56,.64,1)",zIndex:200,pointerEvents:"none",whiteSpace:"nowrap",boxShadow:"0 10px 40px rgba(0,0,0,.5)"}}>{toast.m}</div>
      <Nav act={tab} onChange={doTab} cc={cc} wc={wl.length}/>
    </div>
  );
}
