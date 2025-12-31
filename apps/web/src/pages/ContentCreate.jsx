import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Layout from '../components/Layout';
import api from '../utils/api';

function ContentCreate() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    body: '',
    visibility: 'PUBLIC',
    isPublished: false,
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleChange = (e) => {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value;
    setFormData((prev) => ({
      ...prev,
      [e.target.name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await api.post('/content', formData);
      navigate('/content');
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to create content');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <div>
        <h1>{t('nav.createContent')}</h1>
        <form className="form" onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="title">{t('content.title')}</label>
            <input
              id="title"
              name="title"
              type="text"
              value={formData.title}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="description">{t('content.description')}</label>
            <input
              id="description"
              name="description"
              type="text"
              value={formData.description}
              onChange={handleChange}
            />
          </div>

          <div className="form-group">
            <label htmlFor="body">{t('content.body')}</label>
            <textarea
              id="body"
              name="body"
              value={formData.body}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="visibility">{t('content.visibility')}</label>
            <select id="visibility" name="visibility" value={formData.visibility} onChange={handleChange}>
              <option value="PUBLIC">{t('visibility.PUBLIC')}</option>
              <option value="MALE_ONLY">{t('visibility.MALE_ONLY')}</option>
              <option value="FEMALE_ONLY">{t('visibility.FEMALE_ONLY')}</option>
              <option value="ADMIN_ONLY">{t('visibility.ADMIN_ONLY')}</option>
            </select>
          </div>

          <div className="form-group">
            <label htmlFor="isPublished">
              <input
                id="isPublished"
                name="isPublished"
                type="checkbox"
                checked={formData.isPublished}
                onChange={handleChange}
              />
              {' '}
              {t('content.isPublished')}
            </label>
          </div>

          {error && <div className="error">{error}</div>}

          <div style={{ display: 'flex', gap: '1rem' }}>
            <button type="submit" className="btn btn-primary" disabled={loading}>
              {loading ? t('common.loading') : t('content.create')}
            </button>
            <button type="button" className="btn btn-secondary" onClick={() => navigate('/content')}>
              {t('content.cancel')}
            </button>
          </div>
        </form>
      </div>
    </Layout>
  );
}

export default ContentCreate;
