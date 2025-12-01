// JavaScript cho trang landing page âm nhạc GenZ Beats

(function() {
    'use strict';

    // Lấy context path
    const ctx = window.APP_CONTEXT || '';
    
    // Dữ liệu playlist/thể loại nhạc cho carousel
    const portfolioData = [
        {
            id: 1,
            title: 'V-POP Hits',
            description: 'Những bản hit Việt nổi bật, cập nhật mỗi tuần.',
            image: '/assets/thumbs/vpop.png',
            tech: ['V-POP', 'Ballad', 'Trending']
        },
        {
            id: 2,
            title: 'US-UK Chart',
            description: 'Top US-UK mới nhất: Pop, R&B, Hip-hop.',
            image: '/assets/thumbs/usuk.png',
            tech: ['Pop', 'R&B', 'Hip-hop']
        },
        {
            id: 3,
            title: 'EDM Night',
            description: 'Năng lượng bùng nổ cho buổi tối cuối tuần.',
            image: '/assets/thumbs/edm.png',
            tech: ['EDM', 'Dance', 'Bass']
        },
        {
            id: 4,
            title: 'Lo-fi Chill',
            description: 'Nhạc nhẹ nhàng cho học tập và thư giãn.',
            image: '/assets/thumbs/lofi.png',
            tech: ['Lo-fi', 'Acoustic', 'Focus']
        },
        {
            id: 5,
            title: 'Rap Việt',
            description: 'Lời rap chất, beat căng — nghe là mê.',
            image: '/assets/thumbs/rap.png',
            tech: ['Rap', 'Hip-hop', 'VN']
        },
        {
            id: 6,
            title: 'Indie Acoustic',
            description: 'Âm thanh mộc mạc chạm tới cảm xúc.',
            image: '/assets/thumbs/indie.png',
            tech: ['Indie', 'Acoustic', 'Mood']
        },
        {
            id: 7,
            title: 'Workout Mix',
            description: 'Playlist tăng động lực cho mỗi buổi tập.',
            image: '/assets/thumbs/workout.png',
            tech: ['Workout', 'Pump', 'Energy']
        }
    ];

    // Biến toàn cục cho carousel
    let currentIndex = 0;
    const carousel = document.getElementById('carousel');
    const indicatorsContainer = document.getElementById('indicators');

    // Tạo một item trong carousel
    function createCarouselItem(data, index) {
        const item = document.createElement('div');
        item.className = 'carousel-item';
        item.dataset.index = index;
        
        const techBadges = data.tech.map(tech => 
            `<span class="tech-badge">${tech}</span>`
        ).join('');
        
        const imageSrc = ctx + data.image;
        item.innerHTML = `
            <div class="card">
                <div class="card-number">0${data.id}</div>
                <div class="card-image">
                    <img src="${imageSrc}" alt="${data.title}" onerror="this.src='${ctx}/assets/thumbs/default.png'">
                </div>
                <h3 class="card-title">${data.title}</h3>
                <p class="card-description">${data.description}</p>
                <div class="card-tech">${techBadges}</div>
                <button class="card-cta" onclick="window.location.href='${ctx}/home'">Khám phá</button>
            </div>
        `;
        
        return item;
    }

    // Khởi tạo carousel
    function initCarousel() {
        if (!carousel || !indicatorsContainer) {
            console.warn('Carousel elements not found');
            return;
        }

        // Tạo các carousel items
        portfolioData.forEach((data, index) => {
            const item = createCarouselItem(data, index);
            carousel.appendChild(item);
            
            // Tạo indicator
            const indicator = document.createElement('div');
            indicator.className = 'indicator';
            if (index === 0) indicator.classList.add('active');
            indicator.dataset.index = index;
            indicator.addEventListener('click', () => goToSlide(index));
            indicatorsContainer.appendChild(indicator);
        });
        
        updateCarousel();
    }

    // Cập nhật vị trí carousel
    function updateCarousel() {
        const items = document.querySelectorAll('.carousel-item');
        const indicators = document.querySelectorAll('.indicator');
        const totalItems = items.length;
        
        if (totalItems === 0) return;

        const isMobile = window.innerWidth <= 768;
        const isTablet = window.innerWidth <= 1024;
        
        items.forEach((item, index) => {
            let offset = index - currentIndex;
            
            // Wrap around cho rotation liên tục
            if (offset > totalItems / 2) {
                offset -= totalItems;
            } else if (offset < -totalItems / 2) {
                offset += totalItems;
            }
            
            const absOffset = Math.abs(offset);
            const sign = offset < 0 ? -1 : 1;
            
            item.style.transition = 'all 0.8s cubic-bezier(0.4, 0.0, 0.2, 1)';
            
            // Khoảng cách giữa các items
            let spacing1 = 400;
            let spacing2 = 600;
            let spacing3 = 750;
            
            if (isMobile) {
                spacing1 = 280;
                spacing2 = 420;
                spacing3 = 550;
            } else if (isTablet) {
                spacing1 = 340;
                spacing2 = 520;
                spacing3 = 650;
            }
            
            // Vị trí và transform dựa trên offset
            if (absOffset === 0) {
                // Item ở giữa
                item.style.transform = 'translate(-50%, -50%) translateZ(0) scale(1)';
                item.style.opacity = '1';
                item.style.zIndex = '10';
            } else if (absOffset === 1) {
                const translateX = sign * spacing1;
                const rotation = isMobile ? 25 : 30;
                const scale = isMobile ? 0.88 : 0.85;
                item.style.transform = `translate(-50%, -50%) translateX(${translateX}px) translateZ(-200px) rotateY(${-sign * rotation}deg) scale(${scale})`;
                item.style.opacity = '0.8';
                item.style.zIndex = '5';
            } else if (absOffset === 2) {
                const translateX = sign * spacing2;
                const rotation = isMobile ? 35 : 40;
                const scale = isMobile ? 0.75 : 0.7;
                item.style.transform = `translate(-50%, -50%) translateX(${translateX}px) translateZ(-350px) rotateY(${-sign * rotation}deg) scale(${scale})`;
                item.style.opacity = '0.5';
                item.style.zIndex = '3';
            } else if (absOffset === 3) {
                const translateX = sign * spacing3;
                const rotation = isMobile ? 40 : 45;
                const scale = isMobile ? 0.65 : 0.6;
                item.style.transform = `translate(-50%, -50%) translateX(${translateX}px) translateZ(-450px) rotateY(${-sign * rotation}deg) scale(${scale})`;
                item.style.opacity = '0.3';
                item.style.zIndex = '2';
            } else {
                item.style.transform = 'translate(-50%, -50%) translateZ(-500px) scale(0.5)';
                item.style.opacity = '0';
                item.style.zIndex = '1';
            }
        });
        
        // Cập nhật indicators
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === currentIndex);
        });
    }

    // Chuyển slide tiếp theo
    function nextSlide() {
        currentIndex = (currentIndex + 1) % portfolioData.length;
        updateCarousel();
    }

    // Chuyển slide trước
    function prevSlide() {
        currentIndex = (currentIndex - 1 + portfolioData.length) % portfolioData.length;
        updateCarousel();
    }

    // Đi tới slide cụ thể
    function goToSlide(index) {
        currentIndex = index;
        updateCarousel();
    }

    // Khởi tạo particles cho section philosophy
    function initParticles() {
        const particlesContainer = document.getElementById('particles');
        if (!particlesContainer) return;

        const particleCount = 15;
        
        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = Math.random() * 100 + '%';
            particle.style.animationDelay = Math.random() * 20 + 's';
            particle.style.animationDuration = (18 + Math.random() * 8) + 's';
            particlesContainer.appendChild(particle);
        }
    }

    // Animated counter cho stats
    function animateCounter(element) {
        const target = parseInt(element.dataset.target);
        const duration = 2000;
        const step = target / (duration / 16);
        let current = 0;
        
        const counter = setInterval(() => {
            current += step;
            if (current >= target) {
                element.textContent = target.toLocaleString();
                clearInterval(counter);
            } else {
                element.textContent = Math.floor(current).toLocaleString();
            }
        }, 16);
    }

    // Intersection Observer cho stats animation
    function initStatsObserver() {
        const statsSection = document.querySelector('.stats-section');
        if (!statsSection) return;

        const observerOptions = {
            threshold: 0.5,
            rootMargin: '0px 0px -100px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const statNumbers = entry.target.querySelectorAll('.stat-number');
                    statNumbers.forEach(number => {
                        if (!number.classList.contains('animated')) {
                            number.classList.add('animated');
                            animateCounter(number);
                        }
                    });
                }
            });
        }, observerOptions);

        observer.observe(statsSection);
    }

    // Mobile menu toggle
    function initMobileMenu() {
        const menuToggle = document.getElementById('menuToggle');
        const navMenu = document.getElementById('navMenu');
        
        if (!menuToggle || !navMenu) return;

        menuToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            menuToggle.classList.toggle('active');
        });
    }

    // Header scroll effect
    function initHeaderScroll() {
        const header = document.getElementById('header');
        if (!header) return;

        window.addEventListener('scroll', () => {
            if (window.scrollY > 100) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }

    // Smooth scrolling cho navigation
    function initSmoothScroll() {
        const navLinks = document.querySelectorAll('.nav-link');
        const header = document.getElementById('header');
        const navMenu = document.getElementById('navMenu');
        const menuToggle = document.getElementById('menuToggle');

        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                
                // Chỉ xử lý anchor links (#...)
                if (href && href.startsWith('#')) {
                    e.preventDefault();
                    const targetId = href.substring(1);
                    const targetSection = document.getElementById(targetId);
                    
                    if (targetSection) {
                        const headerHeight = header ? header.offsetHeight : 0;
                        const targetPosition = targetSection.offsetTop - headerHeight;
                        
                        window.scrollTo({
                            top: targetPosition,
                            behavior: 'smooth'
                        });
                        
                        // Đóng mobile menu nếu đang mở
                        if (navMenu) navMenu.classList.remove('active');
                        if (menuToggle) menuToggle.classList.remove('active');
                    }
                }
            });
        });
    }

    // Update active navigation khi scroll
    function initActiveNav() {
        const sections = document.querySelectorAll('section[id]');
        const navLinks = document.querySelectorAll('.nav-link');

        function updateActiveNav() {
            const scrollPosition = window.scrollY + 100;
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.offsetHeight;
                const sectionId = section.getAttribute('id');
                
                if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        const href = link.getAttribute('href');
                        if (href === '#' + sectionId) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        }

        window.addEventListener('scroll', updateActiveNav);
    }

    // Event listeners cho carousel controls
    function initCarouselControls() {
        const nextBtn = document.getElementById('nextBtn');
        const prevBtn = document.getElementById('prevBtn');

        if (nextBtn) nextBtn.addEventListener('click', nextSlide);
        if (prevBtn) prevBtn.addEventListener('click', prevSlide);

        // Auto-rotate carousel
        setInterval(nextSlide, 5000);

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') prevSlide();
            if (e.key === 'ArrowRight') nextSlide();
        });

        // Update carousel khi resize
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
                updateCarousel();
            }, 250);
        });
    }

    // Parallax effect cho hero section
    function initParallax() {
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const parallax = document.querySelector('.hero');
            if (parallax) {
                parallax.style.transform = `translateY(${scrolled * 0.3}px)`;
            }
        });
    }

    // Khởi tạo tất cả khi DOM ready
    function init() {
        console.log('Initializing GenZ Beats landing page...');
        
        // Ẩn loader ngay khi init
        const loader = document.getElementById('loader');
        if (loader) {
            setTimeout(() => {
                loader.style.opacity = '0';
                loader.style.transition = 'opacity 0.5s ease';
                setTimeout(() => {
                    loader.style.display = 'none';
                }, 500);
            }, 300);
        }
        
        initCarousel();
        initCarouselControls();
        initParticles();
        initStatsObserver();
        initMobileMenu();
        initHeaderScroll();
        initSmoothScroll();
        initActiveNav();
        initParallax();
        
        console.log('GenZ Beats initialized successfully!');
    }

    // Chạy khi DOM đã sẵn sàng
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();