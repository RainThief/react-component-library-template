import React from 'react';
import '@testing-library/jest-dom/extend-expect';
import { render, RenderResult } from '@testing-library/react';
import { Alert } from './alert';


describe('Alert', () => {
  let wrapper: RenderResult;
  const description = 'Description';
  const title = 'Title';
  const onCloseSpy: (event: React.FormEvent<HTMLButtonElement>) => void = jest.fn();

  describe('when only the description is specified', () => {
    beforeEach(() => {
      wrapper = render(<Alert>{ description }</Alert>);
    });

    it('should not render the close button', () => {
      expect(wrapper.queryByText('×')).not.toBeInTheDocument();
    });

    it('should not render the title', () => {
      expect(wrapper.queryByText(title)).not.toBeInTheDocument();
    });

    it('should render the description', () => {
      expect(wrapper.getByText(description)).toBeInTheDocument();
    });
  });

  describe('when the description and title is specified', () => {
    beforeEach(() => {
      wrapper = render(<Alert title={title} >{ description }</Alert>);
    });

    it('should not render the close button', () => {
      expect(wrapper.queryByText('×')).not.toBeInTheDocument();
    });

    it('should render the title', () => {
      expect(wrapper.getByText(title)).toBeInTheDocument();
    });

    it('should render the description', () => {
      expect(wrapper.getByText(description)).toBeInTheDocument();
    });
  });


  describe('when the onClose callback is specified', () => {
    beforeEach(() => {
      wrapper = render(<Alert onClose={onCloseSpy}>{ description }</Alert>);
    });

    it('should render the close button', () => {
      expect(wrapper.getByText(/×/)).toBeInTheDocument();
    });

    describe('when the close button is clicked', () => {
      it('should hide the alert', () => {
        wrapper.getByText(/×/).click();
        expect(onCloseSpy).toBeCalledTimes(1);
        expect(wrapper.queryAllByTestId('alert')).toHaveLength(0);
      });
    });
  });
});
