let dataPenyakit = {
"Tanaman Melayu": {
nama: "Tanaman Melayu",
tipe: "Infeksi Jamur",
atasi: "Gunakan fungisida dan perbaiki drainase lahan."
},
"Busuk Akar": {
nama: "Busuk Akar",
tipe: "Jamur Rhizoctonia",
atasi: "Perbaiki sirkulasi tanah dan gunakan agen biologi."
},
"Karat Daun": {
nama: "Karat Daun",
tipe: "Jamur Uredinales",
atasi: "Gunakan fungisida spesifik dan potong daun terinfeksi."
}
};

function diagnosa() {
let pilih = document.getElementById("penyakitSelect").value;
let hasilDiv = document.getElementById("hasil");

if (!pilih) {
hasilDiv.innerHTML = "<p>Silakan pilih penyakit.</p>";
return;
}

let p = dataPenyakit[pilih];

hasilDiv.innerHTML = `
<table class='table'>
<tr><th>Nama Penyakit</th><td>${p.nama}</td></tr>
<tr><th>Tipe Penyakit</th><td>${p.tipe}</td></tr>
<tr><th>Cara Mengatasi</th><td>${p.atasi}</td></tr>
</table>
`;

localStorage.setItem("kesimpulan", p.nama + " - " + p.tipe);
}

window.onload = function() {
let kes = localStorage.getItem("kesimpulan");
if (document.getElementById("kesimpulanText") && kes) {
document.getElementById("kesimpulanText").innerText = kes;
}
};
