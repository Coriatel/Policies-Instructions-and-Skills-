import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../context/AuthContext';

function Layout({ children }) {
  const { t } = useTranslation();
  const location = useLocation();
  const { user, logout } = useAuth();

  const isActive = (path) => location.pathname.startsWith(path);

  return (
    <div className="layout">
      <div className="sidebar">
        <h2>{t('app.title')}</h2>
        <nav className="nav">
          <Link to="/dashboard" className={isActive('/dashboard') ? 'active' : ''}>
            {t('nav.dashboard')}
          </Link>
          <Link to="/content" className={isActive('/content') ? 'active' : ''}>
            {t('nav.content')}
          </Link>
          {user?.role === 'ADMIN' && (
            <Link to="/users" className={isActive('/users') ? 'active' : ''}>
              {t('nav.users')}
            </Link>
          )}
        </nav>
        <div style={{ marginTop: 'auto', paddingTop: '2rem' }}>
          <p>
            {user?.firstName} {user?.lastName}
          </p>
          <p style={{ fontSize: '0.875rem', color: '#6b7280' }}>{t(`roles.${user?.role}`)}</p>
          <button onClick={logout} className="btn btn-danger" type="button" style={{ marginTop: '1rem', width: '100%' }}>
            {t('auth.logout')}
          </button>
        </div>
      </div>
      <div className="main-content">{children}</div>
    </div>
  );
}

export default Layout;
