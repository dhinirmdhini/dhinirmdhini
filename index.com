<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SPK Diagnosa Penyakit Tanaman</title>
  <style>
    :root {
      --brown: #8B5A2B;
      --green: #2E8B57;
      --bg: #f6f4ef;
      --card: #fff;
      --muted: #6b6b6b;
    }
    body{font-family:Inter,Segoe UI,Roboto,Arial; background:linear-gradient(180deg,var(--bg),#ffffff); margin:0; padding:32px; color:#222;}
    .container{max-width:1000px;margin:0 auto;}
    .header{display:flex;align-items:center;gap:16px;margin-bottom:20px;}
    .logo{width:64px;height:64px;border-radius:12px;background:linear-gradient(135deg,var(--brown),var(--green));box-shadow:0 6px 18px rgba(0,0,0,0.12);display:flex;align-items:center;justify-content:center;color:white;font-weight:700;}
    h1{margin:0;font-size:22px;}
    p.lead{margin:4px 0 0;color:var(--muted);}

    .grid{display:grid;grid-template-columns:1fr 420px;gap:20px;align-items:start;}

    /* Card soft + shadow */
    .card{background:var(--card);border-radius:14px;padding:18px;box-shadow:0 8px 24px rgba(99,64,38,0.08);}    
    .card h3{margin-top:0;color:var(--brown);}    
    .select-row{display:flex;gap:12px;flex-direction:column;}
    label{
      font-size:13px;color:#444;font-weight:600;
    }
    select, .chip-list{width:100%;padding:10px;border-radius:10px;border:1px solid #e6e2dc;background:#fff;font-size:14px;}
    .chip-list{min-height:48px;display:flex;flex-wrap:wrap;gap:8px;align-items:center}
    .chip{padding:8px 10px;border-radius:999px;background:#fbf8f6;border:1px solid #efe7de;font-size:13px;color:#3b3b3b;box-shadow:0 4px 10px rgba(0,0,0,0.04)}
    button.primary{background:linear-gradient(90deg,var(--green),#3aa66a);color:white;border:none;padding:10px 14px;border-radius:10px;font-weight:700;cursor:pointer;box-shadow:0 8px 20px rgba(46,139,87,0.14)}
    .result-title{display:flex;align-items:center;gap:12px;}
    .result-badge{background:var(--brown);color:white;padding:6px 10px;border-radius:8px;font-weight:700}
    .muted{color:var(--muted);font-size:13px}

    .members{font-size:14px;display:flex;flex-direction:column;gap:6px}
    .member{padding:8px;border-radius:8px;background:linear-gradient(180deg,#fff,#fbfbfb);border:1px solid #efeae4}
    footer{margin-top:20px;text-align:center;color:var(--muted);font-size:13px}
    @media(max-width:880px){ .grid{grid-template-columns:1fr; } }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <div class="logo">SPK</div>
      <div>
        <h1>SPK Diagnosa Penyakit Tanaman</h1>
        <p class="lead">Pilih tanaman → pilih gejala → dapatkan kemungkinan penyakit. Warna: coklat & hijau. Desain: Card Soft + Shadow.</p>
      </div>
    </div>

    <div class="grid">
      <div class="card" id="leftCard">
        <h3>Pilih Tanaman & Gejala</h3>
        <div class="select-row">
          <div>
            <label for="tanamanSelect">Tanaman</label>
            <select id="tanamanSelect">
              <option value="">-- Pilih Tanaman --</option>
            </select>
          </div>

          <div>
            <label for="gejalaSelect">Gejala (pilih satu atau lebih)</label>
            <select id="gejalaSelect" multiple size="6"></select>
            <div class="muted" style="margin-top:8px">Tahan Ctrl/Cmd untuk memilih lebih dari satu.</div>
          </div>

          <div style="display:flex;gap:10px;align-items:center">
            <button class="primary" id="diagnosaBtn">Diagnosa</button>
            <button id="resetBtn" style="padding:10px;border-radius:10px;background:#fff;border:1px solid #efe7de;cursor:pointer">Reset</button>
          </div>
        </div>

        <div style="margin-top:18px">
          <h4>Gejala terpilih</h4>
          <div class="chip-list" id="selectedChips"></div>
        </div>
      </div>

      <div class="card" id="resultCard">
        <div class="result-title">
          <div class="result-badge">Hasil</div>
          <div>
            <h2 id="resultPenyakit">-</h2>
            <div class="muted" id="resultTanaman"></div>
          </div>
        </div>

        <div style="margin-top:12px">
          <strong>Patogen / Nama ilmiah</strong>
          <div id="resultPatogen" class="muted">-</div>
        </div>

        <div style="margin-top:12px">
          <strong>Alasan (kecocokan gejala)</strong>
          <div id="reasoning" class="muted">Pilih tanaman dan gejala lalu klik Diagnosa.</div>
        </div>

        <hr style="margin:16px 0;border:none;border-top:1px solid #efe7de">

        <h4>Anggota Kelompok</h4>
        <div class="members">
          <div class="member">Dhini Ramadhini — 250311080011</div>
          <div class="member">Sri Mulyani — 250311080010</div>
          <div class="member">Ria R Mokodongan — 250311080008</div>
          <div class="member">Febrianti W. L Wihantou — 25031108001106</div>
          <div class="member">Lisa A Tumuahi — 250311080007</div>
        </div>

      </div>
    </div>

    <footer>
      SPK Diagnosa — data diambil dari berkas Excel internal.
    </footer>
  </div>

  <script>
    // NOTE: This page expects data to be supplied as a JSON array of objects with the fields:
    // {tanaman: string, penyakit: string, patogen: string, gejala: ["gejala1","gejala2"]}
    // For convenience the original Excel file path that you uploaded is:
    // /mnt/data/Tabel_Penyakit_Tanaman (1).xlsx
    // ---
    // Because client-side browsers cannot directly parse .xlsx without extra libraries, there are two easy options:
    // 1) (Recommended) On your machine, convert the Excel to JSON (array) and save as data.json next to this HTML. Example script (Python/pandas):
    //    df = pd.read_excel('Tabel_Penyakit_Tanaman (1).xlsx')
    //    df.to_json('data.json', orient='records', force_ascii=False)
    //    Then place data.json alongside this HTML and the app will load it automatically.
    // 2) Alternatively, embed the DATA array directly in this file by replacing the placeholder below.

    // If you converted Excel to data.json and placed it next to this file, the app will attempt to load it automatically.
    const FALLBACK_JSON = '/mnt/data/data.json';

    // Simple loader: try to fetch data.json, otherwise fall back to embedded DATA variable (if you manually paste it below).
    let DATA = null;

    async function loadData(){
      // Try to fetch JSON file
      try{
        const resp = await fetch(FALLBACK_JSON);
        if(resp.ok){
          DATA = await resp.json();
          initApp();
          return;
        }
      }catch(e){ /* ignore */ }

      // If no external json, try to use embedded placeholder (user can paste JSON array into EMBEDDED_DATA below)
      if(typeof EMBEDDED_DATA !== 'undefined'){
        DATA = EMBEDDED_DATA;
        initApp();
        return;
      }

      // Final fallback: show helpful message
      document.getElementById('leftCard').innerHTML = '<div style="padding:18px">Tidak ada data yang dapat dimuat secara otomatis. Silakan konversi file Excel Anda ke data.json dan letakkan di <code>./data.json</code> atau buka file HTML ini dengan server lokal yang dapat mengakses <code>/mnt/data/Tabel_Penyakit_Tanaman (1).xlsx</code>. Jika mau, saya dapat bantu buatkan versi HTML dengan data yang sudah di-embed.</div>';
    }

    function initApp(){
      // Ensure DATA shape
      if(!Array.isArray(DATA)){
        document.getElementById('leftCard').innerHTML = '<div style="padding:18px">Format data tidak valid. Harus berupa array JSON.</div>';
        return;
      }

      const tanamanSet = Array.from(new Set(DATA.map(d=>d.tanaman))).sort();
      const tanamanSelect = document.getElementById('tanamanSelect');
      const gejalaSelect = document.getElementById('gejalaSelect');
      const selectedChips = document.getElementById('selectedChips');
      const diagnosaBtn = document.getElementById('diagnosaBtn');
      const resetBtn = document.getElementById('resetBtn');

      function populateTanaman(){
        tanamanSet.forEach(t => {
          const opt = document.createElement('option');
          opt.value = t;
          opt.textContent = t;
          tanamanSelect.appendChild(opt);
        });
      }

      function populateGejalaFor(tanaman){
        gejalaSelect.innerHTML = '';
        selectedChips.innerHTML = '';
        if(!tanaman) return;
        const items = DATA.filter(d=>d.tanaman===tanaman);
        const gejalaSet = new Set();
        items.forEach(it=>{ (it.gejala||[]).forEach(g=>gejalaSet.add(g)); });
        const gejalaArr = Array.from(gejalaSet);
        if(gejalaArr.length===0){
          const opt = document.createElement('option'); opt.textContent='(tidak ada gejala tercatat untuk tanaman ini)'; opt.disabled=true; gejalaSelect.appendChild(opt); return;
        }
        gejalaArr.forEach(g=>{ const opt=document.createElement('option'); opt.value=g; opt.textContent=g; gejalaSelect.appendChild(opt); });
      }

      function refreshChips(){ selectedChips.innerHTML=''; const selected = Array.from(gejalaSelect.selectedOptions).map(o=>o.value); selected.forEach(s=>{ const c=document.createElement('div'); c.className='chip'; c.textContent=s; selectedChips.appendChild(c); }); }

      tanamanSelect.addEventListener('change', e=> populateGejalaFor(e.target.value) );
      gejalaSelect.addEventListener('change', refreshChips);

      resetBtn.addEventListener('click', ()=>{
        tanamanSelect.value=''; gejalaSelect.innerHTML=''; selectedChips.innerHTML=''; document.getElementById('resultPenyakit').textContent='-'; document.getElementById('resultTanaman').textContent=''; document.getElementById('resultPatogen').textContent='-'; document.getElementById('reasoning').textContent='Pilih tanaman dan gejala lalu klik Diagnosa.';
      });

      diagnosaBtn.addEventListener('click', ()=>{
        const tanaman = tanamanSelect.value; const selected = Array.from(gejalaSelect.selectedOptions).map(o=>o.value);
        if(!tanaman){ alert('Pilih tanaman terlebih dahulu'); return; }
        if(selected.length===0){ alert('Pilih setidaknya satu gejala'); return; }
        const candidates = DATA.filter(d=>d.tanaman===tanaman).map(d=>{ const matchCount = selected.filter(s => (d.gejala||[]).includes(s)).length; return {...d, matchCount}; }).filter(d=>d.matchCount>0).sort((a,b)=>b.matchCount - a.matchCount);
        if(candidates.length===0){ document.getElementById('resultPenyakit').textContent='Tidak ditemukan'; document.getElementById('resultTanaman').textContent=tanaman; document.getElementById('resultPatogen').textContent='-'; document.getElementById('reasoning').textContent='Tidak ada penyakit dalam data yang memiliki gejala terpilih.'; return; }
        const top = candidates[0]; const topMatches = top.matchCount; const reasoningParts = []; reasoningParts.push(`Gejala terpilih: ${selected.join('; ')}`); reasoningParts.push(`Jumlah gejala cocok: ${topMatches} dari ${selected.length}`); reasoningParts.push(`Sumber data: berkas excel internal.`);
        document.getElementById('resultPenyakit').textContent=top.penyakit; document.getElementById('resultTanaman').textContent=top.tanaman; document.getElementById('resultPatogen').textContent=(top.patogen||'-'); document.getElementById('reasoning').textContent=reasoningParts.join(' | ');
      });

      populateTanaman();
    }

    // Kick off
    loadData();
  </script>
</body>
</html>
