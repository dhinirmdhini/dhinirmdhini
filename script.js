// script.js
// Data penyakit awal (bisa ditambah)
const dataPenyakit = [
  {
    id: 'tanaman-melayu',
    nama: 'Tanaman Melayu',
    penyebab: 'Jamur Fusarium oxysporum',
    gejala: 'Tanaman layu, daun menguning',
    detail: 'Penyakit ini menyebabkan tanaman layu dan daun menguning. Segera lakukan sanitasi dan penggunaan fungisida sesuai anjuran.'
  },
  {
    id: 'busuk-akar',
    nama: 'Busuk Akar',
    penyebab: 'Jamur Rhizoctonia solani',
    gejala: 'Akar membusuk, tanaman mudah roboh',
    detail: 'Ditandai dengan akar membusuk dan tanaman mudah roboh. Perbaiki drainase dan hindari genangan air.'
  },
  {
    id: 'bercak-daun',
    nama: 'Bercak Daun',
    penyebab: 'Jamur Cercospora sp.',
    gejala: 'Bercak coklat pada daun yang meluas',
    detail: 'Muncul bercak coklat pada daun yang makin meluas. Lakukan pemangkasan bagian terinfeksi dan pengendalian jamur.'
  }
];

let anggota = [];
let penyakitDipilih = null;

/* ======= Inisialisasi ======= */
function init(){
  // isi dropdown
  const dd = document.getElementById('dropdownPenyakit');
  dataPenyakit.forEach(p => {
    const opt = document.createElement('option');
    opt.value = p.id;
    opt.textContent = p.nama;
    dd.appendChild(opt);
  });

  // event listeners
  document.getElementById('tambahAnggotaBtn').addEventListener('click', tambahAnggota);
  document.getElementById('diagnosaBtn').addEventListener('click', diagnosa);
  document.getElementById('lihatTabelBtn').addEventListener('click', toggleTabel);
  // populate table (hidden by default)
  renderTable();
}

function tambahAnggota(){
  const input = document.getElementById('anggotaInput');
  const name = input.value && input.value.trim();
  if(!name) return alert('Masukkan nama anggota terlebih dahulu.');
  anggota.push(name);
  input.value = '';
  renderAnggota();
}

function renderAnggota(){
  const div = document.getElementById('anggotaList');
  if(anggota.length === 0){ div.innerHTML = 'Belum ada anggota.'; return; }
  div.innerHTML = anggota.map((a,i) => `${i+1}. ${escapeHtml(a)}`).join('<br>');
}

/* ======= Diagnosa & Tampilan ======= */
function diagnosa(){
  const dd = document.getElementById('dropdownPenyakit');
  const id = dd.value;
  if(!id) return alert('Silakan pilih tipe penyakit dahulu.');
  const data = dataPenyakit.find(p => p.id === id);
  penyakitDipilih = data;
  // tampilkan detail dan scroll ke area tipe
  const detail = document.getElementById('detailDiagnosa');
  detail.innerHTML = `
    <h3>Hasil Diagnosa</h3>
    <p><strong>Penyakit:</strong> ${escapeHtml(data.nama)}</p>
    <p><strong>Penyebab:</strong> ${escapeHtml(data.penyebab)}</p>
    <p><strong>Gejala:</strong> ${escapeHtml(data.gejala)}</p>
    <p><strong>Keterangan:</strong> ${escapeHtml(data.detail)}</p>
  `;
  // update kesimpulan
  const kes = document.getElementById('hasilKesimpulan');
  kes.textContent = 'Kesimpulan: Penyakit yang dipilih adalah ' + data.nama + ' — penyebab: ' + data.penyebab + '.';

  // navigate to kesimpulan section (to follow the user's request where Diagnosa shows data then Kesimpulan should reflect)
  // but keep user on tipe section; we will update hash to #tipe so anchor stays.
  location.hash = '#tipe';
}

function renderTable(){
  const tbody = document.querySelector('#tabelPenyakit tbody');
  tbody.innerHTML = '';
  dataPenyakit.forEach((p, idx) => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${idx+1}</td>
      <td>${escapeHtml(p.nama)}</td>
      <td>${escapeHtml(p.penyebab)}</td>
      <td>${escapeHtml(p.gejala)}</td>
    `;
    tbody.appendChild(tr);
  });
}

function toggleTabel(){
  const tbl = document.getElementById('tabelPenyakit');
  tbl.classList.toggle('hidden');
  // scroll into view
  tbl.scrollIntoView({behavior:'smooth', block:'center'});
}

/* ======= helpers ======= */
function escapeHtml(s){
  if(!s) return '';
  return s.replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('"','&quot;');
}

/* start */
document.addEventListener('DOMContentLoaded', init);
