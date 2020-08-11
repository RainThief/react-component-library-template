import React, { useState } from 'react';


interface AlertProps {
  children: string
  onClose?: (event: React.FormEvent<HTMLButtonElement>) => void
  title?: string
}


export const Alert: React.FC<AlertProps> = ({
  title,
  children,
  onClose,
}: AlertProps) => {
  const [closed, setClosed] = useState(false);

  function handleClick(event: React.FormEvent<HTMLButtonElement>) {
    setClosed(true);
    if (onClose) {
      onClose(event);
    }
  }

  return closed ? null : (<div className="alert alert-primary" role="alert" data-testid="alert">
    { title && (<strong>{ title }</strong>)}
    { children }
    { onClose && (
      <button onClick={handleClick} type="button" className="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    )}
  </div>);

};
