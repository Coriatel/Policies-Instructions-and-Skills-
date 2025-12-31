import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../context/AuthContext';

function Register() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { register } = useAuth();
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    role: 'MALE',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    setFormData((prev) => ({
      ...prev,
      [e.target.name]: e.target.value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await register(formData);
      navigate('/dashboard');
    } catch (err) {
      setError(err.response?.data?.error || t('errors.registrationFailed'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-card">
        <h1>{t('auth.register')}</h1>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="firstName">{t('auth.firstName')}</label>
            <input
              id="firstName"
              name="firstName"
              type="text"
              value={formData.firstName}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="lastName">{t('auth.lastName')}</label>
            <input
              id="lastName"
              name="lastName"
              type="text"
              value={formData.lastName}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="email">{t('auth.email')}</label>
            <input
              id="email"
              name="email"
              type="email"
              value={formData.email}
              onChange={handleChange}
              required
              autoComplete="email"
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">{t('auth.password')}</label>
            <input
              id="password"
              name="password"
              type="password"
              value={formData.password}
              onChange={handleChange}
              required
              autoComplete="new-password"
            />
          </div>

          <div className="form-group">
            <label htmlFor="role">{t('auth.role')}</label>
            <select id="role" name="role" value={formData.role} onChange={handleChange}>
              <option value="MALE">{t('roles.MALE')}</option>
              <option value="FEMALE">{t('roles.FEMALE')}</option>
            </select>
          </div>

          {error && <div className="error">{error}</div>}

          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? t('common.loading') : t('auth.registerButton')}
          </button>
        </form>

        <div className="auth-links">
          <p>
            {t('auth.haveAccount')} <Link to="/login">{t('auth.loginHere')}</Link>
          </p>
        </div>
      </div>
    </div>
  );
}

export default Register;
