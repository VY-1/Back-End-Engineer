const gallery = document.getElementById('gallery');
const viewer = document.getElementById('viewer');
const viewerImage = document.getElementById('viewerImage');
const viewerVideo = document.getElementById('viewerVideo');
const enterVR = document.getElementById('enterVR');
const closeViewer = document.getElementById('closeViewer');

function openViewer(url, type = 'image') {
  viewer.classList.add('active');
  viewerImage.style.display = type === 'image' ? 'block' : 'none';
  viewerVideo.style.display = type === 'video' ? 'block' : 'none';
  if (type === 'image') {
    viewerImage.src = url;
  } else {
    viewerVideo.src = url;
  }
}

closeViewer.addEventListener('click', () => viewer.classList.remove('active'));

enterVR.addEventListener('click', async () => {
  if (!document.documentElement.requestFullscreen) return;
  await document.documentElement.requestFullscreen();
});

// Placeholder gallery items until Spatial3DWebShareServer serves live index JSON.
['Sample SBS Photo', 'Sample SBS Video'].forEach((title, index) => {
  const card = document.createElement('div');
  card.className = 'card';
  card.innerHTML = `<div style="padding:12px">${title}</div>`;
  card.onclick = () => openViewer('', index === 0 ? 'image' : 'video');
  gallery.appendChild(card);
});
