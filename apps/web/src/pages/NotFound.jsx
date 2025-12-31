import { Link } from 'react-router-dom';

function NotFound() {
  return (
    <div className="access-denied">
      <h1>404</h1>
      <p>העמוד לא נמצא</p>
      <Link to="/dashboard" className="btn btn-primary">
        חזרה לדף הבית
      </Link>
    </div>
  );
}

export default NotFound;
