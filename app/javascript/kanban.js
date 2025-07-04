// Função para navegar para a tarefa
function goToTask(event, url) {
  // Verifica se o clique foi no checkbox ou no formulário
  if (event.target.type === 'checkbox' || event.target.closest('.task-form')) {
    return; // Não navega se for o checkbox
  }
  
  // Verifica se o clique foi em um link ou botão
  if (event.target.tagName === 'A' || event.target.tagName === 'BUTTON') {
    return; // Não navega se for um link ou botão
  }
  
  // Navega para a página da tarefa
  window.location.href = url;
}

// Função para alternar tema (opcional)
function toggleTheme() {
  const body = document.body;
  const themeButton = document.querySelector('.user button');
  const icon = themeButton.querySelector('i');
  
  if (body.classList.contains('light-theme')) {
    body.classList.remove('light-theme');
    icon.classList.remove('fa-moon');
    icon.classList.add('fa-sun');
    localStorage.setItem('theme', 'dark');
  } else {
    body.classList.add('light-theme');
    icon.classList.remove('fa-sun');
    icon.classList.add('fa-moon');
    localStorage.setItem('theme', 'light');
  }
}

// Carregar tema salvo
document.addEventListener('DOMContentLoaded', function() {
  const savedTheme = localStorage.getItem('theme');
  const themeButton = document.querySelector('.user button');
  
  if (themeButton) {
    themeButton.addEventListener('click', toggleTheme);
  }
  
  if (savedTheme === 'light') {
    document.body.classList.add('light-theme');
    const icon = themeButton?.querySelector('i');
    if (icon) {
      icon.classList.remove('fa-sun');
      icon.classList.add('fa-moon');
    }
  }
});

// Função para confirmar exclusão
function confirmDelete(message) {
  return confirm(message || 'Tem certeza que deseja excluir este item?');
}

// Função para mostrar loading durante operações
function showLoading(element) {
  const originalText = element.textContent;
  element.textContent = 'Carregando...';
  element.disabled = true;
  
  return function hideLoading() {
    element.textContent = originalText;
    element.disabled = false;
  };
}

// Função para auto-resize de textarea
function autoResize(textarea) {
  textarea.style.height = 'auto';
  textarea.style.height = textarea.scrollHeight + 'px';
}

// Aplicar auto-resize em textareas
document.addEventListener('DOMContentLoaded', function() {
  const textareas = document.querySelectorAll('textarea');
  textareas.forEach(textarea => {
    textarea.addEventListener('input', function() {
      autoResize(this);
    });
    
    // Aplicar no carregamento se já tiver conteúdo
    if (textarea.value) {
      autoResize(textarea);
    }
  });
});

// Função para validar formulários
function validateForm(form) {
  const requiredFields = form.querySelectorAll('[required]');
  let isValid = true;
  
  requiredFields.forEach(field => {
    if (!field.value.trim()) {
      field.classList.add('error');
      isValid = false;
    } else {
      field.classList.remove('error');
    }
  });
  
  return isValid;
}

// Aplicar validação em formulários
document.addEventListener('DOMContentLoaded', function() {
  const forms = document.querySelectorAll('form');
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      if (!validateForm(this)) {
        e.preventDefault();
        
        // Mostrar primeira mensagem de erro
        const firstError = this.querySelector('.error');
        if (firstError) {
          firstError.focus();
          firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      }
    });
  });
});

// Função para mostrar notificações (se necessário)
function showNotification(message, type = 'info') {
  const notification = document.createElement('div');
  notification.className = `notification notification-${type}`;
  notification.textContent = message;
  
  document.body.appendChild(notification);
  
  setTimeout(() => {
    notification.classList.add('show');
  }, 100);
  
  setTimeout(() => {
    notification.classList.remove('show');
    setTimeout(() => {
      document.body.removeChild(notification);
    }, 300);
  }, 3000);
}

// Estilos para notificações
const notificationStyles = `
  .notification {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 16px 24px;
    border-radius: 8px;
    color: #fff;
    font-weight: 500;
    transform: translateX(400px);
    transition: transform 0.3s ease;
    z-index: 10000;
  }
  
  .notification.show {
    transform: translateX(0);
  }
  
  .notification-info {
    background: #3b82f6;
  }
  
  .notification-success {
    background: #10b981;
  }
  
  .notification-error {
    background: #ef4444;
  }
  
  .notification-warning {
    background: #f59e0b;
  }
`;

// Adicionar estilos de notificação
const style = document.createElement('style');
style.textContent = notificationStyles;
document.head.appendChild(style);