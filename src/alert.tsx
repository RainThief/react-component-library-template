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

  if (!closed) {
    return (
      <div className="alert alert-primary" role="alert">
        { title && (<strong>{ title }</strong>)}
        { children }
        <button onClick={handleClick} type="button" className="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    );
  }

  return null;



};


// export const Alert = ({
//   children,
//   onClose,
//   title,
// }): AlertProps  => {
// // export const Alert = ({ title, children, onClose }): AlertProps => {
//   const [closed, setClosed] = useState(false);

//   function handleClick(event: React.FormEvent<HTMLButtonElement>) {
//     setClosed(true);

//     if (onClose) {
//       onClose(event);
//     }
//   }






//   return (
//     !closed && (
//       <div
//         data-testid="alert"
//         role="alert"
//       >
//         <div
//           aria-hidden="true"
//           data-testid="state-icon"
//         >
//         </div>
//         <div className="rn-alert__content" data-testid="content">
//           {title && (
//             <h2
//               className="rn-alert__title"
//               data-testid="content-title"
//             >
//               {title}
//             </h2>
//           )}
//           <p
//             data-testid="content-description"
//           >
//             {children}
//           </p>
//           <div className="rn-alert__footer">
//             <button
//               onClick={handleClick}
//               data-testid="close"
//             >
//               Dismiss
//             </button>
//           </div>
//         </div>
//       </div>
//     )
//   );
// };
