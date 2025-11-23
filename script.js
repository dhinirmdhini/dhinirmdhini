// APP namespace
window.APP = (function(){
  const app = {};
  let currentPage = null;
  let diseases = [];

  async function loadPage(page){
    currentPage = page;
    // update active nav buttons
    document.querySelectorAll('.nav-btn').forEach(b=>{
      b.classList.toggle('active', b.dataset.link === page);
    });
    // fetch page content
    const res = await fetch(page);
    const html = await res.text();
    document.getElementById('app').innerHTML = html;
    // initialize page-specific scripts
    if (page === 'tipe.html') initTipe();
    if (page === 'beranda.html') {/* nothing for now */}
    if (page === 'kesimpulan.html') renderKesimpulan();
  }

  async function loadDiseases(){
    try{
      const res = await fetch('diseases.json');
      diseases = await res.json();
    }catch(e){
      console.error('Gagal memuat diseases.json', e);
      diseases = [];
    }
    return diseases;
  }

  // attach nav
  document.addEventListener('click', (ev)=>{
    const btn = ev.target.closest('.nav-btn');
    if(btn){
      ev.preventDefault();
      const link = btn.dataset.link;
      if(link) loadPage(link);
    }
  });

  /* ========== Tipe page ========== */
  async function initTipe(){
    await loadDiseases();
    const dd = document.getElementById('penyakitSelect');
    const tbody = document.querySelector('#diseasesTable tbody');
    dd.innerHTML = '<option value="">-- Pilih Penyakit --</option>';
    tbody.innerHTML = '';
    diseases.forEach((d,idx)=>{
      const opt = document.createElement('option');
      opt.value = d.id;
      opt.textContent = d.nama;
      dd.appendChild(opt);

      const tr = document.createElement('tr');
      tr.innerHTML = `<td>${idx+1}</td>
                      <td>${escapeHtml(d.nama)}</td>
                      <td>${escapeHtml(d.penyebab)}</td>
                      <td>${escapeHtml(d.keterangan)}</td>
                      <td class="img-cell">${d.image ? '<img src="'+d.image+'" alt="'+escapeHtml(d.nama)+'">' : ''}</td>`;
      tbody.appendChild(tr);
    });

    document.getElementById('diagnosaBtn').addEventListener('click', ()=>{
      const id = dd.value;
      if(!id){ alert('Silakan pilih penyakit dahulu.'); return; }
      const selected = diseases.find(x=>x.id===id);
      if(!selected){ alert('Data penyakit tidak ditemukan.'); return; }
      // render result area as table (nama, penyebab, keterangan, image)
      const out = document.getElementById('diagnosaResult');
      out.innerHTML = `<table class="data-table"><tbody>
        <tr><th>Nama Penyakit</th><td>${escapeHtml(selected.nama)}</td></tr>
        <tr><th>Penyebab</th><td>${escapeHtml(selected.penyebab)}</td></tr>
        <tr><th>Keterangan</th><td>${escapeHtml(selected.keterangan)}</td></tr>
        <tr><th>Gambar</th><td>${selected.image ? '<img src="'+selected.image+'" style="max-width:320px;border-radius:8px">' : '—'}</td></tr>
      </tbody></table>`;
      // save to localStorage for kesimpulan page
      localStorage.setItem('lastDiagnosis', JSON.stringify({id:selected.id,nama:selected.nama,penyebab:selected.penyebab,keterangan:selected.keterangan}));
      // scroll into view
      out.scrollIntoView({behavior:'smooth'});
    });

    document.getElementById('refreshBtn').addEventListener('click', async ()=>{
      await loadDiseases();
      initTipe(); // re-init to refresh
    });
  }

  /* ========== Kesimpulan ========== */
  function renderKesimpulan(){
    const area = document.getElementById('kesimpulanArea');
    const last = localStorage.getItem('lastDiagnosis');
    if(!last){
      area.innerHTML = '<p class="muted">Belum ada diagnosa. Pilih penyakit di menu Tipe Penyakit.</p>';
      return;
    }
    const d = JSON.parse(last);
    area.innerHTML = `<div class="panel"><h3>Ringkasan Diagnosa</h3>
      <p><strong>Penyakit:</strong> ${escapeHtml(d.nama)}</p>
      <p><strong>Penyebab:</strong> ${escapeHtml(d.penyebab)}</p>
      <p><strong>Keterangan singkat:</strong> ${escapeHtml(d.keterangan ? d.keterangan : '—')}</p>
    </div>`;
  }

  /* helpers */
  function escapeHtml(s){ if(!s) return ''; return String(s).replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('"','&quot;'); }

  app.loadPage = loadPage;
  app.loadDiseases = loadDiseases;
  return app;
})();

// HAMBURGER MENU
document.addEventListener('DOMContentLoaded', () => {
  const ham = document.getElementById('hamburgerBtn');
  const nav = document.querySelector('.topnav');

  if (ham && nav) {
    ham.addEventListener('click', () => {
      nav.classList.toggle('show');
    });
  }
});

