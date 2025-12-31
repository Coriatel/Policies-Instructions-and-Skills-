import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Layout from '../components/Layout';
import api from '../utils/api';

function ContentEdit() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { id } = useParams();
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    body: '',
    visibility: 'PUBLIC',
    isPublished: false,
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchContent();
  }, [id]);

  const fetchContent = async () => {
    try {
      const response = await api.get(`/content/${id}`);
      const content = response.data.content;
      setFormData({
        title: content.title,
        description: content.description || '',
        body: content.body,
        visibility: content.visibility,
        isPublished: content.isPublished,
      });
    } catch (err) {
      setError(t('errors.loadingFailed'));
    } finally {
      setLoading(false);
    }
  };

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
    setSaving(true);

    try {
      await api.patch(`/content/${id}`, formData);
      navigate('/content');
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to update content');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <Layout>
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>{t('common.loading')}</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div>
        <h1>{t('content.edit')}</h1>
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
            <button type="submit" className="btn btn-primary" disabled={saving}>
              {saving ? t('common.loading') : t('content.update')}
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

export default ContentEdit;
