// Function to create and setup the Intersection Observer
function setupScrollObserver() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.id;
                const index = Array.from(document.querySelectorAll('.item')).indexOf(entry.target);
                if (index < 5) {
                    // Clear hash when near the top
                    history.replaceState(null, null, window.location.pathname);
                } else {
                    // Update hash for posts after first 5
                    history.replaceState(null, null, `#${id}`);
                }
            }
        });
    }, {
        threshold: 0.5 // Trigger when item is 50% visible
    });

    // Observe all item divs
    document.querySelectorAll('.item').forEach(item => {
        observer.observe(item);
    });
}

// Function to scroll to hash on load
function scrollToHash() {
    if (window.location.hash) {
        const element = document.querySelector(window.location.hash);
        if (element) {
            element.scrollIntoView();
        }
    }
}

// Function to fetch and render the JSON data
async function renderDeviations() {
    const container = document.getElementById('deviations-container');

    try {
        // Fetch the deviations.json file
        const response = await fetch('deviations.json');
        if (!response.ok) {
            throw new Error('Failed to load deviations.json');
        }

        // Parse the JSON data
        const deviations = await response.json();

        // Sort deviations from oldest to newest
        deviations.sort((a, b) => new Date(a.pubDate) - new Date(b.pubDate));

        // Render each item
        deviations.forEach(item => {
            const itemDiv = document.createElement('div');
            itemDiv.className = 'item';
            itemDiv.id = item.title.toLowerCase().replace(/[^a-z0-9]/g, '-');

            // Add title
            const title = document.createElement('h2');
            title.textContent = item.title;
            itemDiv.appendChild(title);

            // Add image
            const image = document.createElement('img');
            image.src = item.content;
            image.alt = item.title;
            image.className = 'post';
            image.loading = 'lazy';
            itemDiv.appendChild(image);

            // Add publish date
            const pubDate = document.createElement('p');
            pubDate.textContent = `Published on: ${item.pubDate}`;
            pubDate.style.fontSize = '0.9em';
            itemDiv.appendChild(pubDate);

            // Add description
            const description = document.createElement('p');
            description.innerHTML = item.description;
            itemDiv.appendChild(description);

            // Append the item to the container
            container.appendChild(itemDiv);
        });
    } catch (error) {
        console.error('Error loading or rendering deviations:', error);
        container.innerHTML = `<p style="color: red;">Error loading deviations: ${error.message}</p>`;
    }
}

// Call the functions to render deviations and setup scroll handling
document.addEventListener('DOMContentLoaded', () => {
    renderDeviations().then(() => {
        setupScrollObserver();
        scrollToHash();
    });
});
